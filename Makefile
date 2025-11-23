# Makefile for Matrix Multiplication Accelerator

# Verilog compiler
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Source files
SOURCES = mac_unit.v \
          processing_element.v \
          matrix_mult_2x2.v \
          matrix_mult_4x4.v \
          matrix_mult_6x6.v \
          matrix_mult_8x8.v \
          memory_controller.v \
          matrix_scheduler.v \
          matrix_accelerator.v

# Testbench
TESTBENCH = tb_matrix_accelerator.v

# Output files
SIMULATION = matrix_sim
VCD_FILE = matrix_sim.vcd

# Default target
all: compile run

# Compile the design
compile: $(SIMULATION)

$(SIMULATION): $(SOURCES) $(TESTBENCH)
	@echo "Compiling Verilog sources..."
	$(IVERILOG) -o $(SIMULATION) $(SOURCES) $(TESTBENCH)
	@echo "Compilation complete."

# Run simulation
run: $(SIMULATION)
	@echo "Running simulation..."
	$(VVP) $(SIMULATION)
	@echo "Simulation complete."

# View waveforms (requires GTKWave)
waves: $(VCD_FILE)
	$(GTKWAVE) $(VCD_FILE) &

# Generate VCD file (modify testbench to include $dumpfile and $dumpvars)
$(VCD_FILE): run

# Clean up generated files
clean:
	@echo "Cleaning up..."
	rm -f $(SIMULATION) $(VCD_FILE)
	@echo "Clean complete."

# Run specific matrix size tests
test-2x2: compile
	@echo "Running 2x2 matrix test..."
	$(VVP) $(SIMULATION) +matrix_size=0

test-4x4: compile
	@echo "Running 4x4 matrix test..."
	$(VVP) $(SIMULATION) +matrix_size=1

test-6x6: compile
	@echo "Running 6x6 matrix test..."
	$(VVP) $(SIMULATION) +matrix_size=2

test-8x8: compile
	@echo "Running 8x8 matrix test..."
	$(VVP) $(SIMULATION) +matrix_size=3

# Run all tests
test-all: test-2x2 test-4x4 test-6x6 test-8x8

# Python-based testing
test-python: compile
	@echo "Running Python test suite..."
	python3 test_matrix_accelerator.py

test-simple: compile
	@echo "Running simple Python test..."
	python3 test_simple.py
	$(IVERILOG) -o $(SIMULATION) $(SOURCES) tb_simple_test.v
	$(VVP) $(SIMULATION)

test-interactive:
	@echo "Starting interactive test mode..."
	python3 test_matrix_accelerator.py --interactive

# Automated test runner
test-auto:
	@echo "Running automated test suite..."
	./run_tests.sh --comprehensive

# Syntax check only
syntax-check:
	@echo "Checking syntax..."
	$(IVERILOG) -t null $(SOURCES) $(TESTBENCH)
	@echo "Syntax check passed."

# Help target
help:
	@echo "Available targets:"
	@echo "  all           - Compile and run simulation"
	@echo "  compile       - Compile Verilog sources"
	@echo "  run           - Run simulation"
	@echo "  waves         - View waveforms with GTKWave"
	@echo "  clean         - Remove generated files"
	@echo "  test-2x2      - Run 2x2 matrix test"
	@echo "  test-4x4      - Run 4x4 matrix test" 
	@echo "  test-6x6      - Run 6x6 matrix test"
	@echo "  test-8x8      - Run 8x8 matrix test"
	@echo "  test-all      - Run all matrix size tests"
	@echo "  test-python   - Run comprehensive Python test suite"
	@echo "  test-simple   - Run simple Python-generated test"
	@echo "  test-interactive - Interactive Python test mode"
	@echo "  test-auto     - Automated test runner script"
	@echo "  syntax-check  - Check Verilog syntax"
	@echo "  help          - Show this help message"

.PHONY: all compile run waves clean test-2x2 test-4x4 test-6x6 test-8x8 test-all test-python test-simple test-interactive test-auto syntax-check help