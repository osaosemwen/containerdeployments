FROM python:2.7-slim
WORKDIR /app
ADD . /app
#RUN apt-get install -y wget
RUN pip install --trusted-host pypi.python.org -r requirements.txt
EXPOSE 80
ENV NAME World
CMD ["python", "app.py"]
#ENV http_proxy host:port

