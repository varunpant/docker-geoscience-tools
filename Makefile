img=geo-work-bench
default: image test notebook

.PHONY: image shell

image:
	docker build --tag ${img}:latest .

test:
	docker run -it --rm ${img}:latest python -c "import rasterio, fiona, shapely, numpy, sys; print('Python:', sys.version); print('Rasterio:', rasterio.__version__); print('Fiona:', fiona.__version__); print('Shapely:', shapely.__version__); print('Numpy', numpy.__version__);"

shell: image
	docker run -it --rm ${img}:latest /bin/bash

notebook:
	docker run -it --rm \
		-p 0.0.0.0:8888:8888 \
		--rm \
		--interactive \
		--tty \
		--volume $(shell pwd)/notebooks/:/notebooks \
		${img}:latest  /bin/bash -c "cd /notebooks && jupyter notebook --ip=0.0.0.0 --allow-root"