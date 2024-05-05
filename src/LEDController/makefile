# Variables
VHDL_FILES = LED_Controller_icebreaker_top.vhd LEDController.vhd ../PWMGenerator/PWMGenerator.vhd
TOP_MODULE = LED_Controller_icebreaker_top
BUILD_DIR = ../../build/LEDController
PCF_FILE = ../../constraints/icebreaker.pcf

# Main target
all: analyze synthesize pnr generate_bitstream program_fpga clean

# Rule to create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Rule to analyze VHDL sources
analyze: $(BUILD_DIR) $(VHDL_FILES)
	ghdl -a $(VHDL_FILES)

# Rule to synthesize the design
synthesize: analyze
	yosys -m ghdl -p 'ghdl $(TOP_MODULE); synth_ice40 -json $(BUILD_DIR)/$(TOP_MODULE).json'

# Rule for place and route
pnr: synthesize
	nextpnr-ice40 --up5k --package sg48 --freq 2 --pcf $(PCF_FILE) --asc $(BUILD_DIR)/$(TOP_MODULE).asc --json $(BUILD_DIR)/$(TOP_MODULE).json

# Rule to generate bitstream
generate_bitstream: pnr
	icepack $(BUILD_DIR)/$(TOP_MODULE).asc $(BUILD_DIR)/$(TOP_MODULE).bin

# Rule to program FPGA
program_fpga: generate_bitstream
	iceprog $(BUILD_DIR)/$(TOP_MODULE).bin

# Clean
clean:
	rm -rf $(BUILD_DIR) *.cf *.json

.PHONY: all analyze synthesize pnr generate_bitstream program_fpga clean

