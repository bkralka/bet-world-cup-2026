# 1. Bierzemy gotowego, lekkiego Pythona
FROM python:3.11-slim

# 2. Tworzymy folder /app wewnątrz kontenera
WORKDIR /app

# 3. Kopiujemy listę bibliotek i je instalujemy
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Kopiujemy resztę naszego kodu
COPY . .

# 5. Odpalamy serwer (z opcją --reload, żeby sam się odświeżał jak zmienisz kod)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]