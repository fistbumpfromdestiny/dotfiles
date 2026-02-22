;;; cobol-config.el --- COBOL development config for Doom Emacs -*- lexical-binding: t; -*-
;;
;; Provides:
;;   1. cobol-mode with syntax highlighting & indentation
;;   2. Broadcom COBOL LSP via lsp-mode (auto-downloads server)
;;   3. Zowe CLI integration with elisp wrappers
;;
;; ============================================================
;; SETUP
;; ============================================================
;;
;; 1. In ~/.config/doom/init.el, make sure you have:
;;      lsp               ; (NOT (lsp +eglot))
;;
;; 2. In ~/.config/doom/packages.el, add:
;;      (package! cobol-mode)
;;
;; 3. In ~/.config/doom/config.el, add:
;;      (load! "cobol-config")
;;
;; 4. Run: doom sync
;;
;; 5. Open a .cbl file — lsp-mode auto-downloads the COBOL LSP
;;    server JAR on first use. Java 17+ must be on your PATH.
;;
;; 6. (Optional) Install Zowe CLI for mainframe interaction:
;;      npm install -g @zowe/cli
;;
;; ============================================================


;; ────────────────────────────────────────────────────────────
;; 1. COBOL MAJOR MODE
;; ────────────────────────────────────────────────────────────

(use-package! cobol-mode
  :mode (("\\.cob\\'" . cobol-mode)
         ("\\.cbl\\'" . cobol-mode)
         ("\\.cpy\\'" . cobol-mode)    ; copybooks
         ("\\.pco\\'" . cobol-mode))   ; Pro*COBOL
  :config
  (setq cobol-source-format 'fixed)
  (setq cobol-tab-width 4))


;; ────────────────────────────────────────────────────────────
;; 2. LSP-MODE COBOL (auto-download, auto-connect)
;; ────────────────────────────────────────────────────────────

;; lsp-mode already knows about the Broadcom COBOL LSP server.
;; Just hook it up to cobol-mode and it handles the rest.
(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(cobol-mode . "cobol")))

(add-hook! 'cobol-mode-hook #'lsp!)

;; Customize if needed (defaults usually work fine):
;; (after! lsp-mode
;;   ;; Change the server version if needed:
;;   ;; (setq lsp-cobol-server-version "2.4.3")
;;   ;;
;;   ;; Point to a specific Java if not on PATH:
;;   ;; (setq lsp-java-java-path "/usr/lib/jvm/java-17/bin/java")
;;   ;;
;;   ;; Change the TCP port (default 1044):
;;   ;; (setq lsp-cobol-port 1044)
;;   )


;; ────────────────────────────────────────────────────────────
;; 3. COBOL QUALITY OF LIFE — Permanent column ruler
;; ────────────────────────────────────────────────────────────
;;
;; COBOL fixed-format column boundaries (1-based):
;;   Col  1-6  : Sequence number area
;;   Col  7    : Indicator column (* = comment, - = continuation)
;;   Col  8-11 : Area A (divisions, sections, paragraphs, 01/77)
;;   Col 12-72 : Area B (statements, clauses)
;;   Col 73-80 : Identification area (ignored by compiler)
;;
;; Displays a permanent ruler in the header line.

(defface cobol-ruler-face
  '((t (:inherit header-line :foreground "#888888")))
  "Face for the COBOL column ruler.")

(defface cobol-ruler-boundary-face
  '((t (:inherit header-line :foreground "#cc8844" :weight bold)))
  "Face for boundary markers in the COBOL column ruler.")

(defun cobol--make-ruler ()
  "Build a propertized COBOL column ruler string for `header-line-format'."
  (let* ((width 80)
         ;; Standard ruler: ----+----1----+----2----+----3 ...
         (ruler (cl-loop for i from 1 to width
                         concat (cond
                                 ((= (% i 10) 0)
                                  (number-to-string (/ i 10)))
                                 ((= (% i 5) 0) "+")
                                 (t "-")))))
    ;; Apply base face
    (put-text-property 0 (length ruler) 'face 'cobol-ruler-face ruler)
    ;; Highlight boundary columns (0-based: 6=col7, 7=col8, 11=col12, 71=col72)
    (dolist (col '(6 7 11 71))
      (when (< col (length ruler))
        (put-text-property col (1+ col) 'face 'cobol-ruler-boundary-face ruler)))
    ruler))

(defun cobol--header-ruler ()
  "Return `header-line-format' with padding for line number gutter.
Evaluated dynamically so it adapts to line-number width changes."
  '(:eval
    (let* ((ruler (cobol--make-ruler))
           ;; line-number-display-width gives the current gutter width in columns
           (gutter (if (bound-and-true-p display-line-numbers-mode)
                       (+ (line-number-display-width) 2)  ; +2 for padding
                     0))
           (pad (make-string gutter ?\s)))
      (concat pad ruler))))

(defun cobol-setup ()
  "Set up COBOL permanent column ruler and quality-of-life features."
  (setq header-line-format (cobol--header-ruler))
  (column-number-mode 1))

(add-hook 'cobol-mode-hook #'cobol-setup)

;; Local leader keybindings
(map! :map cobol-mode-map
      :localleader
      "f" #'cobol-format-line
      "F" #'cobol-format-region)


;; ────────────────────────────────────────────────────────────
;; 4. ZOWE CLI INTEGRATION
;; ────────────────────────────────────────────────────────────

(defgroup zowe nil
  "Zowe CLI integration for Emacs."
  :group 'tools
  :prefix "zowe-")

(defcustom zowe-profile nil
  "Zowe z/OSMF profile name. If nil, uses the default profile."
  :type '(choice (const nil) string)
  :group 'zowe)

(defun zowe--cmd (&rest args)
  "Build a Zowe CLI command string from ARGS.
Appends --rfj (response format JSON) and profile if set."
  (let ((base (string-join (cons "zowe" (flatten-list args)) " ")))
    (concat base
            " --rfj"
            (when zowe-profile (format " --zosmf-profile %s" zowe-profile)))))

(defun zowe--run (cmd &optional callback)
  "Run CMD asynchronously. Parse JSON output and call CALLBACK with result.
If CALLBACK is nil, display output in a buffer."
  (let ((buf (generate-new-buffer " *zowe-output*")))
    (set-process-sentinel
     (start-process-shell-command "zowe" buf cmd)
     (lambda (proc _event)
       (when (eq (process-status proc) 'exit)
         (with-current-buffer (process-buffer proc)
           (goto-char (point-min))
           (condition-case nil
               (let ((json (json-parse-buffer :object-type 'alist)))
                 (if callback
                     (funcall callback json)
                   (zowe--display-json json)))
             (error
              (message "Zowe: %s" (buffer-string)))))
         (unless callback
           (kill-buffer (process-buffer proc))))))))

(defun zowe--display-json (json)
  "Display parsed JSON response in a formatted buffer."
  (let ((buf (get-buffer-create "*Zowe Output*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert (pp-to-string json))
        (goto-char (point-min))
        (special-mode)))
    (pop-to-buffer buf)))

;; -- Dataset Operations ──────────────────────────────────────

(defun zowe-list-datasets (pattern)
  "List datasets matching PATTERN (e.g. \"IBMUSER.*\")."
  (interactive "sDataset pattern: ")
  (zowe--run
   (zowe--cmd "zos-files" "list" "ds" (format "\"%s\"" pattern))
   (lambda (json)
     (let* ((items (alist-get 'data (alist-get 'data json)))
            (buf (get-buffer-create "*Zowe Datasets*")))
       (with-current-buffer buf
         (let ((inhibit-read-only t))
           (erase-buffer)
           (insert (format "Datasets matching: %s\n" pattern))
           (insert (make-string 60 ?-) "\n")
           (seq-doseq (item items)
             (let ((dsn (alist-get 'dsname item)))
               (insert-text-button dsn
                                   'action (lambda (_) (zowe-list-members dsn))
                                   'follow-link t)
               (insert "\n")))
           (goto-char (point-min))
           (special-mode)))
       (pop-to-buffer buf)))))

(defun zowe-list-members (dataset)
  "List members of a PDS DATASET."
  (interactive "sDataset (PDS): ")
  (zowe--run
   (zowe--cmd "zos-files" "list" "am" (format "\"%s\"" dataset))
   (lambda (json)
     (let* ((items (alist-get 'data (alist-get 'data json)))
            (buf (get-buffer-create (format "*Zowe Members: %s*" dataset))))
       (with-current-buffer buf
         (let ((inhibit-read-only t))
           (erase-buffer)
           (insert (format "Members of: %s\n" dataset))
           (insert (make-string 60 ?-) "\n")
           (seq-doseq (item items)
             (let ((member (alist-get 'member item)))
               (insert-text-button member
                                   'action (lambda (_)
                                             (zowe-download-member dataset member))
                                   'follow-link t)
               (insert "\n")))
           (goto-char (point-min))
           (special-mode)))
       (pop-to-buffer buf)))))

(defun zowe-download-member (dataset member)
  "Download MEMBER from DATASET and open it in a COBOL buffer."
  (interactive "sDataset: \nsMember: ")
  (let* ((local-dir (expand-file-name "zowe-downloads" (temporary-file-directory)))
         (local-file (expand-file-name (format "%s(%s).cbl" dataset member) local-dir)))
    (make-directory local-dir t)
    (zowe--run
     (format "zowe zos-files download ds \"%s(%s)\" -f \"%s\" %s"
             dataset member local-file
             (if zowe-profile (format "--zosmf-profile %s" zowe-profile) ""))
     (lambda (_json)
       (find-file local-file)
       (setq-local zowe--remote-dataset dataset)
       (setq-local zowe--remote-member member)
       (message "Downloaded %s(%s)" dataset member)))))

(defun zowe-upload-member ()
  "Upload current buffer back to its originating dataset member."
  (interactive)
  (unless (and (boundp 'zowe--remote-dataset) zowe--remote-dataset)
    (user-error "This buffer wasn't downloaded via Zowe"))
  (let ((dataset zowe--remote-dataset)
        (member zowe--remote-member)
        (file (buffer-file-name)))
    (save-buffer)
    (zowe--run
     (format "zowe zos-files upload ftu \"%s\" \"%s(%s)\" %s"
             file dataset member
             (if zowe-profile (format "--zosmf-profile %s" zowe-profile) ""))
     (lambda (_json)
       (message "Uploaded %s -> %s(%s)" (file-name-nondirectory file) dataset member)))))

;; -- JCL / Job Operations ────────────────────────────────────

(defun zowe-submit-jcl (dataset-member)
  "Submit JCL from DATASET-MEMBER (e.g. \"IBMUSER.JCL(COMPILE)\")."
  (interactive "sDataset(Member): ")
  (zowe--run
   (zowe--cmd "zos-jobs" "submit" "ds" (format "\"%s\"" dataset-member))
   (lambda (json)
     (let* ((data (alist-get 'data json))
            (jobid (alist-get 'jobid data))
            (jobname (alist-get 'jobname data)))
       (message "Submitted %s - Job: %s (%s)" dataset-member jobname jobid)
       (when (y-or-n-p "View job output when complete? ")
         (zowe--poll-job jobid))))))

(defun zowe-submit-local-jcl ()
  "Submit the current buffer as JCL from local file."
  (interactive)
  (save-buffer)
  (zowe--run
   (zowe--cmd "zos-jobs" "submit" "lf" (format "\"%s\"" (buffer-file-name)))
   (lambda (json)
     (let* ((data (alist-get 'data json))
            (jobid (alist-get 'jobid data))
            (jobname (alist-get 'jobname data)))
       (message "Submitted local JCL - Job: %s (%s)" jobname jobid)
       (when (y-or-n-p "View job output when complete? ")
         (zowe--poll-job jobid))))))

(defun zowe--poll-job (jobid &optional attempts)
  "Poll JOBID status until complete, then show spool output."
  (let ((attempts (or attempts 0)))
    (when (> attempts 60)
      (user-error "Timed out waiting for job %s" jobid))
    (zowe--run
     (zowe--cmd "zos-jobs" "view" "jsbj" jobid)
     (lambda (json)
       (let ((status (alist-get 'status (alist-get 'data json))))
         (if (member status '("OUTPUT" "ABEND"))
             (zowe-view-spool jobid)
           (message "Job %s status: %s (polling...)" jobid status)
           (run-at-time 3 nil #'zowe--poll-job jobid (1+ attempts))))))))

(defun zowe-view-spool (jobid)
  "View all spool files for JOBID."
  (interactive "sJob ID: ")
  (zowe--run
   (zowe--cmd "zos-jobs" "view" "sfba" jobid)
   (lambda (json)
     (let ((buf (get-buffer-create (format "*Zowe Spool: %s*" jobid)))
           (data (alist-get 'data json)))
       (with-current-buffer buf
         (let ((inhibit-read-only t))
           (erase-buffer)
           (insert (format "Spool output for: %s\n" jobid))
           (insert (make-string 72 ?=) "\n\n")
           (if (stringp data)
               (insert data)
             (insert (pp-to-string data)))
           (goto-char (point-min))
           (special-mode)))
       (pop-to-buffer buf)))))

(defun zowe-list-jobs (&optional prefix)
  "List jobs, optionally filtered by PREFIX."
  (interactive "sJob name prefix (empty for all): ")
  (let ((cmd (if (string-empty-p prefix)
                 (zowe--cmd "zos-jobs" "list" "jobs")
               (zowe--cmd "zos-jobs" "list" "jobs" "--prefix" prefix))))
    (zowe--run cmd
               (lambda (json)
                 (let* ((jobs (alist-get 'data json))
                        (buf (get-buffer-create "*Zowe Jobs*")))
                   (with-current-buffer buf
                     (let ((inhibit-read-only t))
                       (erase-buffer)
                       (insert "Jobs\n")
                       (insert (make-string 72 ?-) "\n")
                       (insert (format "%-10s %-10s %-10s %s\n"
                                       "JOBID" "JOBNAME" "STATUS" "RETCODE"))
                       (insert (make-string 72 ?-) "\n")
                       (seq-doseq (job jobs)
                         (let ((jobid (alist-get 'jobid job)))
                           (insert-text-button
                            (format "%-10s %-10s %-10s %s"
                                    jobid
                                    (or (alist-get 'jobname job) "")
                                    (or (alist-get 'status job) "")
                                    (or (alist-get 'retcode job) ""))
                            'action (lambda (_) (zowe-view-spool jobid))
                            'follow-link t)
                           (insert "\n")))
                       (goto-char (point-min))
                       (special-mode)))
                   (pop-to-buffer buf))))))

;; -- Zowe Keybindings ────────────────────────────────────────

(map! :leader
      (:prefix ("z" . "zowe")
       :desc "List datasets"      "d" #'zowe-list-datasets
       :desc "List members"       "m" #'zowe-list-members
       :desc "Download member"    "g" #'zowe-download-member
       :desc "Upload member"      "p" #'zowe-upload-member
       :desc "Submit JCL (ds)"    "s" #'zowe-submit-jcl
       :desc "Submit JCL (local)" "S" #'zowe-submit-local-jcl
       :desc "List jobs"          "j" #'zowe-list-jobs
       :desc "View spool"         "o" #'zowe-view-spool))
