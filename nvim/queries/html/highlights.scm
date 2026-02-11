; extends

; Better HTML highlighting - attribute values use @string.special for distinct color
((attribute
  (quoted_attribute_value) @string.special)
  (#set! priority 105))

; Vue directives - v-bind shorthand (:attr)
((attribute_name) @keyword
  (#lua-match? @keyword "^:"))

; Vue directives - v-on shorthand (@event)
((attribute_name) @function
  (#lua-match? @function "^@"))

; Vue directives - v-* (v-if, v-for, v-model, v-on, v-bind, etc.)
((attribute_name) @keyword
  (#lua-match? @keyword "^v%-"))
