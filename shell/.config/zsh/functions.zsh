function jrnl_daily_entry() {
  jrnl now: "$@. @daily_entry @shipper-saas"
  jrnl -n 1
}

function jrnl_daily_report() {
  jrnl -from yesterday @daily_entry @shipper-saas
}
