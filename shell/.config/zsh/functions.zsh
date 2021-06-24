function jrnl_daily_entry() {
  jrnl now: "$@. @daily_entry @shipper-saas"
}

function jrnl_daily_report() {
  jrnl -from yesterday @daily_entry @shipper-saas
}
