FROM pytorch/pytorch:2.7.1-cuda12.8-cudnn9-devel
ENV TORCH_CUDA_ARCH_LIST "8.6"
RUN apt update && apt upgrade -y && apt -y autoremove
RUN DEBIAN_FRONTEND=noninteractive apt install -y git libaio-dev libmpich-dev build-essential

RUN python -m pip install --upgrade pip setuptools wheel
RUN pip install jupyter\
	gekko\
	numpy\
	mpi4py\
	unsloth\
	matplotlib\
	compel

RUN pip install bitsandbytes optimum transformers==4.51.3
RUN pip install auto-gptq --no-build-isolation

WORKDIR /
RUN mkdir -p /root/.jupyter && touch /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py && \
 echo c.NotebookApp.open_browser = False >> /root/.jupyter/jupyter_notebook_config.py

WORKDIR /mnt
CMD jupyter notebook --allow-root --NotebookApp.token='' --ServerApp.iopub_msg_rate_limit=2000 --ServerApp.rate_limit_window=10
