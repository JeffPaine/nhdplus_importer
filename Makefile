# nhdplus_importer

DATABASE_NAME = nhd
DATABASE_LAYER_NAME = flowline

DOWNLOAD_BASE_URL = http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/

SNAPSHOT_FILE_URLS = \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusCA/NHDPlusV21_CA_18_NHDSnapshot_04.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusCO/NHDPlus14/NHDPlusV21_CO_14_NHDSnapshot_04.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusCO/NHDPlus15/NHDPlusV21_CO_15_NHDSnapshot_03.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusGB/NHDPlusV21_GB_16_NHDSnapshot_05.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusGL/NHDPlusV21_GL_04_NHDSnapshot_07.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusMA/NHDPlusV21_MA_02_NHDSnapshot_03.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusMS/NHDPlus05/NHDPlusV21_MS_05_NHDSnapshot_05.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusMS/NHDPlus06/NHDPlusV21_MS_06_NHDSnapshot_06.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusMS/NHDPlus07/NHDPlusV21_MS_07_NHDSnapshot_04.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusMS/NHDPlus08/NHDPlusV21_MS_08_NHDSnapshot_03.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusMS/NHDPlus10L/NHDPlusV21_MS_10L_NHDSnapshot_05.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusMS/NHDPlus10U/NHDPlusV21_MS_10U_NHDSnapshot_06.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusMS/NHDPlus11/NHDPlusV21_MS_11_NHDSnapshot_04.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusNE/NHDPlusV21_NE_01_NHDSnapshot_03.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusPN/NHDPlusV21_PN_17_NHDSnapshot_04.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusRG/NHDPlusV21_RG_13_NHDSnapshot_04.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusSA/NHDPlus03N/NHDPlusV21_SA_03N_NHDSnapshot_03.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusSA/NHDPlus03S/NHDPlusV21_SA_03S_NHDSnapshot_03.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusSA/NHDPlus03W/NHDPlusV21_SA_03W_NHDSnapshot_03.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusSR/NHDPlusV21_SR_09_NHDSnapshot_04.7z \
	http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/NHDPlusTX/NHDPlusV21_TX_12_NHDSnapshot_04.7z \

SNAPSHOT_FILE_BASENAMES = $(foreach i,$(SNAPSHOT_FILE_URLS),$(basename $(notdir $(i))))

7Z_FILES = $(patsubst %,7zip/%.7z,$(SNAPSHOT_FILE_BASENAMES))
SHP_FILES = $(patsubst %,data/%/NHDFlowline.shp,$(SNAPSHOT_FILE_BASENAMES))
DBF_FILES = $(patsubst %,data/%/NHDFlowline.dbf,$(SNAPSHOT_FILE_BASENAMES))
SHX_FILES = $(patsubst %,data/%/NHDFlowline.shx,$(SNAPSHOT_FILE_BASENAMES))
PRJ_FILES = $(patsubst %,data/%/NHDFlowline.prj,$(SNAPSHOT_FILE_BASENAMES))


# Download all NHDSnapshot files from the NHDPlus site
download_snapshots: $(7Z_FILES)

# Decompress the NHD snapshot flowline shapefiles
decompress_flowlines: $(SHP_FILES) $(DBF_FILES) $(SHX_FILES) $(PRJ_FILES)

# Import flowline shapefiles into PostgreSQL
# CREATE DATABASE nhd;
# CREATE EXTENSION postgis;
# CREATE INDEX flowline_gix on flowline USING GIST (wkb_geometry);
# CREATE INDEX gnis_id_index ON flowline(gnis_id);
# VACUUM ANALYZE;
import_flowlines:
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_CA_18_NHDSnapshot_04/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_CO_14_NHDSnapshot_04/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_CO_15_NHDSnapshot_03/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_GB_16_NHDSnapshot_05/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_GL_04_NHDSnapshot_07/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_MA_02_NHDSnapshot_03/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_MS_05_NHDSnapshot_05/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_MS_06_NHDSnapshot_06/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_MS_07_NHDSnapshot_04/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_MS_08_NHDSnapshot_03/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_MS_10L_NHDSnapshot_05/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_MS_10U_NHDSnapshot_06/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_MS_11_NHDSnapshot_04/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_NE_01_NHDSnapshot_03/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_PN_17_NHDSnapshot_04/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_RG_13_NHDSnapshot_04/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_SA_03N_NHDSnapshot_03/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_SA_03S_NHDSnapshot_03/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_SA_03W_NHDSnapshot_03/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_SR_09_NHDSnapshot_04/NHDFlowline.shp
	ogr2ogr -f "ESRI Shapefile" PG:"dbname=$(DATABASE_NAME)" -append -nlt MULTILINESTRING -nln $(DATABASE_LAYER_NAME) data/NHDPlusV21_TX_12_NHDSnapshot_04/NHDFlowline.shp


# Decompress all NHDSnapshot Flowline files
# Not a great design here as you have to process each *.7z file four times, however, I'm not
# sure there's a better way to do it while still mainting individual file checking / recreation.
data/%/NHDFlowline.shp: 7zip/%.7z
	mkdir -p $(dir $@)
	7z e -o$(dir $@) $< -ssc- */*/NHDSnapshot/Hydrography/NHDFlowline$(suffix $@)
	touch $@

data/%/NHDFlowline.dbf: 7zip/%.7z
	mkdir -p $(dir $@)
	7z e -o$(dir $@) $< -ssc- */*/NHDSnapshot/Hydrography/NHDFlowline$(suffix $@)
	touch $@

data/%/NHDFlowline.shx: 7zip/%.7z
	mkdir -p $(dir $@)
	7z e -o$(dir $@) $< -ssc- */*/NHDSnapshot/Hydrography/NHDFlowline$(suffix $@)
	touch $@

data/%/NHDFlowline.prj: 7zip/%.7z
	mkdir -p $(dir $@)
	7z e -o$(dir $@) $< -ssc- */*/NHDSnapshot/Hydrography/NHDFlowline$(suffix $@)
	touch $@


# Download all NHDSnapshot files
7zip/NHDPlusV21_CA_18_NHDSnapshot_04.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusCA/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_CO_14_NHDSnapshot_04.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusCO/NHDPlus14/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_CO_15_NHDSnapshot_03.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusCO/NHDPlus15/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_GB_16_NHDSnapshot_05.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusGB/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_GL_04_NHDSnapshot_07.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusGL/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_MA_02_NHDSnapshot_03.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusMA/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_MS_05_NHDSnapshot_05.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusMS/NHDPlus05/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_MS_06_NHDSnapshot_06.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusMS/NHDPlus06/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_MS_07_NHDSnapshot_04.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusMS/NHDPlus07/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_MS_08_NHDSnapshot_03.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusMS/NHDPlus08/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_MS_10L_NHDSnapshot_05.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusMS/NHDPlus10L/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_MS_10U_NHDSnapshot_06.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusMS/NHDPlus10U/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_MS_11_NHDSnapshot_04.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusMS/NHDPlus11/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_NE_01_NHDSnapshot_03.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusNE/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_PN_17_NHDSnapshot_04.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusPN/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_RG_13_NHDSnapshot_04.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusRG/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_SA_03N_NHDSnapshot_03.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusSA/NHDPlus03N/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_SA_03S_NHDSnapshot_03.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusSA/NHDPlus03S/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_SA_03W_NHDSnapshot_03.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusSA/NHDPlus03W/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_SR_09_NHDSnapshot_04.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusSR/$(notdir $@)' --output-document=$@.download
	mv $@.download $@

7zip/NHDPlusV21_TX_12_NHDSnapshot_04.7z:
	mkdir -p $(dir $@)
	wget '$(DOWNLOAD_BASE_URL)NHDPlusTX/$(notdir $@)' --output-document=$@.download
	mv $@.download $@
