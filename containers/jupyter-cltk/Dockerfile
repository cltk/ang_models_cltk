FROM python:3

LABEL maintainer=johnstewart@aya.yale.edu

WORKDIR cltk

RUN pip install cltk jupyter numpy

COPY load_models.py load_models.py

RUN python load_models.py

EXPOSE 8080

CMD ["bash"]