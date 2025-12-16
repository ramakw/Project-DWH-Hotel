    SET search_path TO dwh_hotel;

    CREATE TABLE fakta_reservasi_kamar (
        reservasi_kamar_key   BIGSERIAL PRIMARY KEY,

        waktu_key             INT  NOT NULL REFERENCES dim_waktu(waktu_key),
        kamar_key             INT  NOT NULL REFERENCES dim_kamar(kamar_key),
        tamu_key              INT  NOT NULL REFERENCES dim_tamu(tamu_key),

        jumlah_malam_menginap INT  NOT NULL
    );

    CREATE TABLE fakta_penjualan (
        penjualan_key     BIGSERIAL PRIMARY KEY,

        produk_key        BIGINT NOT NULL REFERENCES dim_produk(produk_key),
        waktu_key         INT    NOT NULL REFERENCES dim_waktu(waktu_key),

        qty_terjual       NUMERIC(12,2) NOT NULL,
        total_pendapatan  NUMERIC(12,2) NOT NULL
    );