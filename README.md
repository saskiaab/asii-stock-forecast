
# Time Series Forecasting: Saham ASII.JK (Astra International)

Analisis data historis saham PT Astra International Tbk (ASII.JK) dengan pendekatan **time series modeling (MA(1))** menggunakan bahasa pemrograman R. Proyek ini menampilkan proses data cleaning, eksplorasi, modeling, dan forecasting return serta harga saham harian.

---

## Tujuan Proyek

- Mengambil dan memproses data historis harga penutupan saham ASII.JK dari Yahoo Finance
- Menghitung **simple return harian**
- Mengidentifikasi dan membangun model **Moving Average MA(1)**
- Melakukan perbandingan model dengan AR(1) dan ARMA(1,1)
- Memprediksi return dan harga saham dalam jangka pendek (5 hari)
- Visualisasi prediksi dengan **confidence interval**

---

## Tools & Library

- Bahasa: `R`
- Library: `quantmod`, `tseries`, `forecast`, `ggplot2`, `dplyr`

---

## Dataset

- Sumber: Yahoo Finance (`ASII.JK`)
- Periode: **1 Agustus 2021 – 20 April 2025**
- Variabel utama: Harga penutupan harian (`Close`)

---

## Visualisasi Hasil

### Return Forecast
![](plots/return_forecast.png)

### Harga Saham Forecast
![](plots/price_forecast.png)

---

## Hasil Utama

- Model **MA(1)** menunjukkan performa baik berdasarkan AIC/BIC dan diagnostik residual
- Prediksi return menunjukkan fluktuasi kecil dalam 5 hari ke depan
- Harga saham diproyeksikan naik/turun dalam rentang tertentu dengan confidence interval 95%

---

## Struktur File

```
📂 asii-stock-forecast/
├── 📄 README.md
├── 📄 asii_forecast.R     # Script utama analisis
├── 📁 plots/              # Folder visualisasi (.png)
└── 📁 output/             # (Opsional) Hasil prediksi .csv/.txt
```

---

## Kontak

Saskia – [https://linkedin.com/in/saskiaiqlimab]
Email: [saskiabilhaq@gmail.com]  
Portofolio lainnya: [https://github.com/saskiaab]
