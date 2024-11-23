FROM python:3.12 AS base

SHELL ["/bin/bash", "-c"]

WORKDIR /tmp

RUN pip install --upgrade pip
RUN pip install pyodide-build
RUN mkdir wheels

# Set up Emscripten SDK, v3.1.72, 2024-11-19

WORKDIR /tmp
RUN git clone --depth 1 --branch 3.1.72 https://github.com/emscripten-core/emsdk.git
WORKDIR /tmp/emsdk
RUN PYODIDE_EMSCRIPTEN_VERSION=$(pyodide config get emscripten_version) && \
    ./emsdk install ${PYODIDE_EMSCRIPTEN_VERSION} && \
    ./emsdk activate ${PYODIDE_EMSCRIPTEN_VERSION}

# spaCy, v3.7.5, 2024-05-31
# https://github.com/explosion/spacy/tags

WORKDIR /tmp
RUN git clone --depth 1 --branch v3.7.5 https://github.com/explosion/spaCy.git
WORKDIR /tmp/spaCy
RUN source /tmp/emsdk/emsdk_env.sh && pyodide build
RUN cp dist/*.whl /tmp/wheels

# cymem, v1.0.0, 2023-11-03
# https://github.com/explosion/cymem/tags

WORKDIR /tmp
RUN git clone --depth 1 --branch release-v1.0.0 https://github.com/explosion/cymem.git
WORKDIR /tmp/cymem
RUN source /tmp/emsdk/emsdk_env.sh && pyodide build
RUN cp dist/*.whl /tmp/wheels

# preshed, v3.0.8, 2022-10-14
# https://github.com/explosion/preshed/tags

WORKDIR /tmp
RUN git clone --depth 1 --branch v3.0.8 https://github.com/explosion/preshed.git
WORKDIR /tmp/preshed
RUN source /tmp/emsdk/emsdk_env.sh && pyodide build
RUN cp dist/*.whl /tmp/wheels

# murmurhash, v1.0.10, 2023-09-15
# https://github.com/explosion/murmurhash/tags

WORKDIR /tmp
RUN git clone --depth 1 --branch v1.0.10 https://github.com/explosion/murmurhash.git
WORKDIR /tmp/murmurhash
RUN source /tmp/emsdk/emsdk_env.sh && pyodide build
RUN cp dist/*.whl /tmp/wheels

# thinc, v8.2.3, 2024-02-07
# https://github.com/explosion/thinc/tags

WORKDIR /tmp
RUN git clone --depth 1 --branch v8.2.3 https://github.com/explosion/thinc.git
WORKDIR /tmp/thinc
RUN source /tmp/emsdk/emsdk_env.sh && pyodide build
RUN cp dist/*.whl /tmp/wheels

# blis, v0.7.11, 2023-09-20
# https://github.com/explosion/cython-blis/tags

WORKDIR /tmp
RUN git clone --depth 1 --branch v0.7.11 https://github.com/explosion/cython-blis.git
WORKDIR /tmp/cython-blis
RUN source /tmp/emsdk/emsdk_env.sh && BLIS_ARCH=generic pyodide build
RUN cp dist/*.whl /tmp/wheels

# srsly, v.2.4.8, 2023-09-18
# https://github.com/explosion/srsly/tags

WORKDIR /tmp
RUN git clone --depth 1 --branch v2.4.8 https://github.com/explosion/srsly.git
WORKDIR /tmp/srsly
RUN source /tmp/emsdk/emsdk_env.sh && pyodide build
RUN cp dist/*.whl /tmp/wheels

# # marisa-trie, 1.1.1, 2023-05-06
# # https://github.com/pytries/marisa-trie/tags

# WORKDIR /tmp
# RUN git clone --depth 1 --branch 1.1.1 https://github.com/pytries/marisa-trie.git
# WORKDIR /tmp/marisa-trie
# RUN source /tmp/emsdk/emsdk_env.sh && pyodide build
# RUN cp dist/*.whl /tmp/wheels

WORKDIR /tmp
CMD ["bash"]
