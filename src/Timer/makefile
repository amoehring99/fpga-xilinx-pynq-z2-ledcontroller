# A:
file_main = Timer
file_pcf = ../../constraints/icebreaker

module_top = timer
entity_top = $(module_top)

# Directory to store generated files
BUILD_DIR = ../../build/Timer

####################################################################################################

# B:
all: $(BUILD_DIR)/$(file_main).bin

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/$(file_main).bin: $(BUILD_DIR) $(file_main).vhd $(file_pcf).pcf
	yosys \
		-m ghdl \
		-p "ghdl $(file_main).vhd -e $(entity_top); write_verilog $(BUILD_DIR)/$(file_main).v"
	yosys \
		-p "synth_ice40 -top $(module_top) -blif $(BUILD_DIR)/$(file_main).blif" \
		$(BUILD_DIR)/$(file_main).v
	arachne-pnr \
		-d 5k \
		-P sg48 \
		-o $(BUILD_DIR)/$(file_main).asc \
		-p $(file_pcf).pcf $(BUILD_DIR)/$(file_main).blif
	icepack $(BUILD_DIR)/$(file_main).asc $(BUILD_DIR)/$(file_main).bin
	iceprog $(BUILD_DIR)/$(file_main).bin

clean:
	rm -rf $(BUILD_DIR)

.PHONY: clean

