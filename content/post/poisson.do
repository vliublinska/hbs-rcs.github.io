webuse ships, clear
xtset ship

program define categorical
  xtpoisson accident i.yr_con, fe robust

  // coefficients: beta
  margins , dydx(yr_con)

  // subtract base level: exp(beta) - exp(0)
  margins , dydx(yr_con) predict(nu0)
end

// what happens with a continuous variable?
generate log_service = log(service)
xtpoisson accident log_service, fe robust

// coefficient: beta
margins , dydx(log_service)

// exponentiated: exp(beta) - exp(0)
margins , dydx(log_service) predict(nu0)

generate log_accident = log(1 + accident)
xtreg log_accident i.yr_con, fe robust
margins , eydx(yr_con)
