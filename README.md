# nhdplus_importer

A makefile to download the [NHD Plus dataset](http://www.horizon-systems.com/nhdplus/) and (optionally) import the data into PostgreSQL.

## Download

```bash
$ wget https://github.com/JeffPaine/nhdplus_importer/archive/master.zip
$ unzip master.zip -d nhdplus_importer
$ cd nhdplus_importer/
```

## Usage

### Download all snapshots
```bash
make download_snapshots
```

### Decompress all snapshots
```bash
make decompress_flowlines
```

### Import all the flowlines into PostgreSQL

This assumes the existence of a database names `nhd`
```bash
make import_flowlines
```
