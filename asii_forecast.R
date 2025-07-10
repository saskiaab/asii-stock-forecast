# Library
library(quantmod)
library(tseries)
library(forecast)
library(ggplot2)
library(dplyr)

# Folder
dir.create("plots", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)

# Download data saham ASII.JK
getSymbols("ASII.JK", src = "yahoo", from = "2021-08-01", to = "2025-04-20")

# Hitung simple return harian
returns <- dailyReturn(Cl(ASII.JK), type = "arithmetic") |> na.omit()

# Plot harga penutupan dan return
ts.plot(Cl(ASII.JK), main = "Harga Penutupan ASII.JK")
ts.plot(returns, main = "Simple Return Harian ASII.JK")

# Uji stasioneritas
adf.test(returns)

# Plot ACF dan PACF
acf(returns, main = "ACF Simple Return")
pacf(returns, main = "PACF Simple Return")

# Estimasi model MA(1)
model_ma1 <- Arima(returns, order = c(0, 0, 1))
summary(model_ma1)

# Diagnostik residual
resid_ma1 <- residuals(model_ma1)
ts.plot(resid_ma1, main = "Residual MA(1)")
acf(resid_ma1, main = "ACF Residual MA(1)")
Box.test(resid_ma1, lag = 10, type = "Ljung-Box")

# Bandingkan AIC BIC model lain
model_ar1 <- Arima(returns, order = c(1, 0, 0))
model_arma11 <- Arima(returns, order = c(1, 0, 1))

model_comparison <- data.frame(
  Model = c("MA(1)", "AR(1)", "ARMA(1,1)"),
  AIC = c(AIC(model_ma1), AIC(model_ar1), AIC(model_arma11)),
  BIC = c(BIC(model_ma1), BIC(model_ar1), BIC(model_arma11))
)

# Forecast 5 hari
forecast_result <- forecast(model_ma1, h = 5)
print(forecast_result)
ts.plot(forecast_result, main = "Prediksi Simple Return ASII.JK")

# Siapkan data untuk plot
last_price <- as.numeric(tail(Cl(ASII.JK), 1))
forecasted_price <- last_price * cumprod(1 + forecast_result$mean)
upper_price <- last_price * cumprod(1 + forecast_result$upper[, 2])
lower_price <- last_price * cumprod(1 + forecast_result$lower[, 2])

# Visualisasi return
df_return_hist <- tail(returns, 50) |> fortify.zoo() |> rename(Waktu = Index, Return = 2)
df_return_forecast <- data.frame(
  Waktu = seq(max(df_return_hist$Waktu) + 1, by = "day", length.out = 5),
  Return = forecast_result$mean,
  Lower = forecast_result$lower[, 2],
  Upper = forecast_result$upper[, 2]
)

ggplot() +
  geom_line(data = df_return_hist, aes(Waktu, Return)) +
  geom_line(data = df_return_forecast, aes(Waktu, Return), color = "blue") +
  geom_ribbon(data = df_return_forecast, aes(Waktu, ymin = Lower, ymax = Upper),
              fill = "blue", alpha = 0.5) +
  labs(title = "Prediksi Return Saham ASII.JK", x = "Waktu", y = "Return") +
  theme_minimal()
ggsave("plots/return_forecast.png")

# Visualisasi harga
df_hist <- tail(Cl(ASII.JK), 50) |> fortify.zoo() |> rename(Waktu = Index, Harga = 2)
df_price_forecast <- data.frame(
  Waktu = seq(max(df_hist$Waktu) + 1, by = "day", length.out = 5),
  Harga = forecasted_price,
  Lower = lower_price,
  Upper = upper_price
)

ggplot() +
  geom_line(data = df_hist, aes(Waktu, Harga)) +
  geom_line(data = df_price_forecast, aes(Waktu, Harga), color = "blue") +
  geom_ribbon(data = df_price_forecast, aes(Waktu, ymin = Lower, ymax = Upper),
              fill = "blue", alpha = 0.5) +
  labs(title = "Forecast Harga Saham ASII.JK", x = "Waktu", y = "Harga") +
  theme_minimal()
ggsave("plots/price_forecast.png")

write.csv(data.frame(Tanggal = time(forecast_result$mean),
                     Return = as.numeric(forecast_result$mean),
                     Lower = forecast_result$lower[,2],
                     Upper = forecast_result$upper[,2]),
          "output/forecast_return.csv", row.names = FALSE)


write.csv(data.frame(Tanggal = time(forecast_result$mean),
                     Harga = as.numeric(forecasted_price),
                     Lower = as.numeric(lower_price),
                     Upper = as.numeric(upper_price)),
          "output/forecast_price.csv", row.names = FALSE)

write.csv(model_comparison, "output/model_comparison.csv", row.names = FALSE)

capture.output(summary(model_ma1), file = "output/model_summary.txt")
