FROM jupyter/datascience-notebook:ad3574d3c5c7

RUN pip install iisignature
RUN pip install kmapper
# RUN pip install sklearn
RUN pip install networkx

RUN pip install git+https://github.com/kb1dds/pysheaf.git
RUN julia -e 'using Pkg; Pkg.add("HDF5")'
RUN julia -e 'using Pkg; Pkg.add("JLD")'
RUN julia -e 'using Pkg; Pkg.add("Plotly")'
RUN julia -e 'using Pkg; Pkg.add("Eirene")'
RUN julia -e 'using Pkg; Pkg.add("Combinatorics")'
RUN julia -e 'using Pkg; Pkg.add("SparseArrays")'
RUN julia -e 'using Pkg; Pkg.add("Plots")'
RUN julia -e 'using Pkg; Pkg.add("MAT")'
RUN julia -e 'using Pkg; Pkg.add("Statistics")'
RUN julia -e 'using Pkg; Pkg.add("LightGraphs")'
RUN julia -e 'using Pkg; Pkg.add("DataFrames")'
RUN julia -e 'using Pkg; Pkg.add("PyCall")'
RUN julia -e 'using Pkg; Pkg.add("LinearAlgebra")'
RUN julia -e 'using Pkg; Pkg.add("GraphPlot")'

USER root
RUN apt-get update && apt-get install -y \
  libz-dev

USER jovyan

# COPY PersistentHomologyExample.ipynb .
# COPY data .
# COPY PH_helper_functions.jl .
# COPY SheavesExample.ipynb .
# COPY PathSignaturesExamples.ipynb .
# COPY MapperExamples.ipynb .
# COPY pysheaf .

# RUN python setup.py install
# RUN pip install pysheaf




EXPOSE 8888
