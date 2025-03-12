# Base image olarak resmi Python sürümünü kullan
FROM python:3.12

# Sistem bağımlılıklarını yükle (GDAL ve GEOS için gerekli kütüphaneler)
RUN apt-get update && apt-get install -y \
    gdal-bin \
    libgdal-dev \
    libgeos-dev \
    && rm -rf /var/lib/apt/lists/*

# Çevre değişkenlerini tanımla
ENV GDAL_LIBRARY_PATH=/usr/lib/libgdal.so
ENV GEOS_LIBRARY_PATH=/usr/lib/libgeos_c.so

# Çalışma dizinini belirle
WORKDIR /app

# Gerekli dosyaları kopyala
COPY . /app/

# Sanal ortam oluştur ve bağımlılıkları yükle
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Çalıştırma komutu
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "GeoDeer.wsgi:application"]
