# Start from the base image
FROM openroad/flow-ubuntu22.04-dev

# Update the package lists and install wget, Python tools, and build essentials
RUN apt-get update && apt-get install -y wget python3-pip build-essential

# Download the .deb package
RUN wget https://github.com/Precision-Innovations/OpenROAD/releases/download/2024-06-13/openroad_2.0_amd64-ubuntu22.04-2024-06-13.deb

# Install the .deb package
RUN apt-get install -y ./openroad_2.0_amd64-ubuntu22.04-2024-06-13.deb

# Install Jupyter Notebook and additional libraries
RUN pip3 install jupyter kahypar networkx hypernetx matplotlib pandas numpy

# Create a Jupyter kernel for OpenROAD
RUN mkdir -p /root/.local/share/jupyter/kernels/openroad && \
    echo '{"display_name": "OpenROAD", "language": "python", "argv": ["/usr/bin/openroad", "-python", "-m", "ipykernel_launcher", "-f", "{connection_file}"]}' > /root/.local/share/jupyter/kernels/openroad/kernel.json

# Verify that the libraries are available in the OpenROAD Python environment
RUN /usr/bin/openroad -python -c "import kahypar, networkx, hypernetx, matplotlib, pandas, numpy; print('All required libraries are available')"

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm openroad_2.0_amd64-ubuntu22.04-2024-06-13.deb

# Expose the Jupyter Notebook port
EXPOSE 8888

# Set the working directory
WORKDIR /notebooks

# Start Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]