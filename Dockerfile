# Python 3.10 kullanarak temel bir Docker imajı oluştur
FROM python:3.10

# Çalışma dizinini belirle
WORKDIR /app

# Bağımlılıkları yüklemek için gerekli sistem paketlerini kur
RUN apt-get update && apt-get install -y \
    libpq-dev gcc curl && \
    rm -rf /var/lib/apt/lists/*

# Sanal ortam oluştur ve bağımlılıkları yükle
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Pip ve bağımlılıkları güncelle
RUN python -m pip install --upgrade pip setuptools wheel

# Proje dosyalarını konteynere kopyala
COPY . .

# Gerekli bağımlılıkları yükle
RUN pip install --no-cache-dir -r requirements.txt

# Django için statik dosyaları topla
RUN python manage.py collectstatic --noinput

# Container başlatıldığında çalışacak komut
CMD ["gunicorn", "GeoDeer.wsgi:application", "--bind", "0.0.0.0:8000"]
