# MiniGPU - Matrix Acceleration Engine# MiniGPU - Matrix Acceleration Engine



A comprehensive hardware-accelerated matrix multiplication system combining Verilog HDL processing elements with a modern web interface and CPU performance comparison.A comprehensive hardware-accelerated matrix multiplication system combining Verilog HDL processing elements with a modern web interface and CPU performance comparison.



## 🚀 Features



- **Hardware Acceleration**: Dedicated Verilog modules for 2x2, 3x3, and 4x4 matrix multiplication## 🚀 Features## Architecture Overview

- **Scalable Processing**: Support for matrix sizes from 2x2 to 8x8

- **Intelligent Scheduling**: Automatic routing to optimal processing method

- **Modern Web Interface**: Professional UI with responsive design

- **Real-time Computation**: Instant matrix multiplication with verification- **Hardware Acceleration**: Dedicated Verilog modules for 2x2, 3x3, and 4x4 matrix multiplicationThe accelerator consists of the following key components:

- **CPU Performance Comparison**: Benchmarks hardware acceleration against CPU methods

- **Scalable Processing**: Support for matrix sizes from 2x2 to 8x8

## 🏗️ Architecture

- **Intelligent Scheduling**: Automatic routing to optimal processing method### 1. MAC Unit (`mac_unit.v`)

### Processing Elements

- `matrix_mult_2x2_simple.v`: Hardware accelerator for 2x2 matrices- **Modern Web Interface**: Professional UI with responsive design- **Purpose**: Multiply-Accumulate operations (result = accumulator + a × b)

- `matrix_mult_3x3.v`: Hardware accelerator for 3x3 matrices  

- `matrix_mult_4x4.v`: Hardware accelerator for 4x4 matrices- **Real-time Computation**: Instant matrix multiplication with verification- **Features**: 



### Web Application  - 16-bit signed input data

- `app_enhanced.py`: Flask backend with intelligent scheduler and CPU benchmarking

- `templates/index_enhanced.html`: Modern responsive frontend with performance visualization## 🏗️ Architecture  - 32-bit accumulator for overflow protection



### Design Philosophy  - Clear accumulator functionality

- **2x2-4x4**: Hardware-accelerated using dedicated Verilog modules

- **5x5-8x8**: Optimized software computation for larger matrices### Processing Elements  - Valid output signal

- **Verification**: NumPy-based result validation

- **Performance Analysis**: Real-time comparison between hardware and CPU methods- `matrix_mult_2x2_simple.v`: Hardware accelerator for 2x2 matrices



## 🔧 Installation- `matrix_mult_3x3.v`: Hardware accelerator for 3x3 matrices  ### 2. Processing Element (`processing_element.v`)



1. **Install Dependencies**:- `matrix_mult_4x4.v`: Hardware accelerator for 4x4 matrices- **Purpose**: Wrapper around MAC unit for systolic array implementation

   ```bash

   pip install -r requirements.txt- **Features**:

   ```

### Web Application  - Pass-through inputs for systolic data flow

2. **Install Verilog Simulator**:

   ```bash- `app_enhanced.py`: Flask backend with intelligent scheduler  - Individual MAC unit per PE

   sudo apt-get install iverilog

   ```- `templates/index_enhanced.html`: Modern responsive frontend  - Enable and clear controls



3. **Compile Hardware Modules**:

   ```bash

   make compile### Design Philosophy### 3. Matrix Multiplication Units

   ```

- **2x2-4x4**: Hardware-accelerated using dedicated Verilog modules- **`matrix_mult_2x2.v`**: 4 PEs for 2×2 matrices

## 🎯 Usage

- **5x5-8x8**: Optimized software computation for larger matrices- **`matrix_mult_4x4.v`**: 16 PEs for 4×4 matrices  

1. **Start the Web Server**:

   ```bash- **Verification**: NumPy-based result validation- **`matrix_mult_6x6.v`**: 36 PEs for 6×6 matrices

   python app_enhanced.py

   ```- **`matrix_mult_8x8.v`**: 64 PEs for 8×8 matrices



2. **Access the Interface**:## 🔧 Installation

   Open `http://localhost:5001` in your browser

Each unit implements a state machine with:

3. **Perform Matrix Multiplication**:

   - Select matrix size (2x2 to 8x8)1. **Install Dependencies**:- IDLE: Wait for start signal

   - Input matrix values or use defaults

   - Click "Accelerate" for instant results with performance comparison   ```bash- CLEAR: Reset all accumulators



## 🎨 UI Design   pip install -r requirements.txt- COMPUTE: Perform matrix multiplication cycles



Modern professional interface featuring:   ```- DONE: Output results

- **White** backgrounds for clarity

- **Charcoal Black** text for readability

- **Orange** accents for interactive elements

- Responsive grid layouts2. **Install Verilog Simulator**:### 4. Memory Controller (`memory_controller.v`)

- Real-time performance charts

- CPU vs Hardware comparison visualization   ```bash- **Purpose**: Manage input/output matrix storage



## 🧪 Technical Specifications   sudo apt-get install iverilog- **Features**:



- **Language**: Verilog HDL (IEEE Standard Compatible)   ```  - Separate storage for matrices A, B, and result C

- **Simulator**: Icarus Verilog (iverilog)

- **Backend**: Flask Python Framework  - Dual-port access (external + internal)

- **Frontend**: HTML5, CSS3, JavaScript

- **Verification**: NumPy Mathematical Libraries3. **Compile Hardware Modules**:  - Configurable addressing

- **Performance Analysis**: Real-time CPU benchmarking

   ```bash  - Result storage with extended precision

## 📁 Project Structure

   make compile

```

MiniGPU/   ```### 5. Matrix Scheduler (`matrix_scheduler.v`)

├── matrix_mult_2x2_simple.v    # 2x2 Hardware Accelerator

├── matrix_mult_3x3.v           # 3x3 Hardware Accelerator- **Purpose**: Coordinate computation based on matrix size

├── matrix_mult_4x4.v           # 4x4 Hardware Accelerator

├── app_enhanced.py             # Flask Application with CPU Comparison## 🎯 Usage- **Features**:

├── templates/

│   └── index_enhanced.html     # Web Interface with Performance Charts  - Automatic PE array selection (2×2, 4×4, 6×6, 8×8)

├── requirements.txt            # Python Dependencies

├── Makefile                    # Build Configuration1. **Start the Web Server**:  - State machine for computation flow

└── README.md                   # Documentation

```   ```bash  - Memory interface management



## 🔬 Performance Analysis   python app_enhanced.py  - Result collection and storage



- **Hardware Acceleration**: Parallel processing for small matrices   ```

- **CPU Comparison**: Real-time benchmarking against naive and optimized CPU methods

- **Performance Visualization**: Interactive charts showing execution time comparison### 6. Top-Level Integration (`matrix_accelerator.v`)

- **Speedup Metrics**: Quantified performance gains with detailed analysis

- **Educational Value**: Demonstrates simulation overhead vs real hardware benefits2. **Access the Interface**:- **Purpose**: Complete system integration



## 🚀 Getting Started   Open `http://localhost:5000` in your browser- **Features**:



The system is ready to use immediately after installation. The web interface provides intuitive controls for matrix input and instant computation results with comprehensive performance analysis.  - All component instantiation



## 📊 Performance Features3. **Perform Matrix Multiplication**:  - Signal routing and multiplexing



- **CPU Naive Benchmark**: Standard O(n³) matrix multiplication timing   - Select matrix size (2x2 to 8x8)  - External interface provision

- **CPU Optimized Benchmark**: NumPy vectorized operations timing  

- **Hardware Simulation**: Verilog HDL parallel processing timing   - Input matrix values or use defaults  - Unified control interface

- **Speedup Analysis**: Comparative performance metrics

- **Visual Charts**: Interactive performance comparison graphs   - Click "Calculate" for instant results



---## Usage Instructions



*MiniGPU Matrix Acceleration Engine - Bridging hardware acceleration with modern web interfaces and performance analysis*## 🎨 UI Design

### 1. Loading Input Matrices

Modern professional interface featuring:

- **White** backgrounds for clarity```verilog

- **Charcoal Black** text for readability// Example: Load 2x2 matrices

- **Orange** accents for interactive elements// Matrix A: [1 2; 3 4]

- Responsive grid layoutsmem_write_enable = 1;

- Real-time input validationmem_matrix_select = 2'b00; // Select matrix A



## 🧪 Technical Specificationsmem_address = 0; mem_write_data = 1; @(posedge clk); // a00

mem_address = 1; mem_write_data = 2; @(posedge clk); // a01  

- **Language**: Verilog HDL (IEEE Standard Compatible)mem_address = 2; mem_write_data = 3; @(posedge clk); // a10

- **Simulator**: Icarus Verilog (iverilog)mem_address = 3; mem_write_data = 4; @(posedge clk); // a11

- **Backend**: Flask Python Framework

- **Frontend**: HTML5, CSS3, JavaScript// Matrix B: [5 6; 7 8]  

- **Verification**: NumPy Mathematical Librariesmem_matrix_select = 2'b01; // Select matrix B

mem_address = 0; mem_write_data = 5; @(posedge clk); // b00

## 📁 Project Structuremem_address = 1; mem_write_data = 6; @(posedge clk); // b01

mem_address = 2; mem_write_data = 7; @(posedge clk); // b10  

```mem_address = 3; mem_write_data = 8; @(posedge clk); // b11

MiniGPU/```

├── matrix_mult_2x2_simple.v    # 2x2 Hardware Accelerator

├── matrix_mult_3x3.v           # 3x3 Hardware Accelerator### 2. Starting Computation

├── matrix_mult_4x4.v           # 4x4 Hardware Accelerator

├── app_enhanced.py             # Flask Application```verilog

├── templates/matrix_size = 3'b000;      // 0: 2x2, 1: 4x4, 2: 6x6, 3: 8x8

│   └── index_enhanced.html     # Web Interfacestart_computation = 1;

├── requirements.txt            # Python Dependencies@(posedge clk);

├── Makefile                    # Build Configurationstart_computation = 0;

└── README.md                   # Documentation

```// Wait for completion

wait(computation_done);

## 🔬 Performance```



- **Hardware Acceleration**: Sub-microsecond computation for small matrices### 3. Reading Results

- **Scalable Architecture**: Efficient processing for matrices up to 8x8

- **Web Response**: Real-time results with instant feedback```verilog

- **Verification**: Automatic correctness checking// Read result matrix C

mem_matrix_select = 2'b10; // Lower 16 bits of result

## 🚀 Getting Startedmem_read_enable = 1;



The system is ready to use immediately after installation. The web interface provides intuitive controls for matrix input and instant computation results.for (i = 0; i < matrix_elements; i = i + 1) begin

    mem_address = i;

---    @(posedge clk);

    result_value = mem_read_data;

*Matrix Acceleration Engine - Bridging hardware acceleration with modern web interfaces*    // Process result_value
end

mem_read_enable = 0;
```

## Matrix Size Encoding

| matrix_size | Matrix Dimensions | Number of Elements | Computation Cycles |
|-------------|-------------------|-------------------|-------------------|
| 3'b000      | 2×2              | 4                 | 2                 |
| 3'b001      | 4×4              | 16                | 4                 |  
| 3'b010      | 6×6              | 36                | 6                 |
| 3'b011      | 8×8              | 64                | 8                 |

## Memory Layout

### Input Matrices (Flattened Row-Major Order)
For an N×N matrix, element (i,j) is stored at address: `i*N + j`

Example 2×2 matrix:
```
[a00 a01]  ->  Address: [0, 1, 2, 3]
[a10 a11]      Values:  [a00, a01, a10, a11]
```

### Memory Select Encoding
- `2'b00`: Matrix A
- `2'b01`: Matrix B  
- `2'b10`: Result matrix C (lower 16 bits)
- `2'b11`: Result matrix C (upper 16 bits)

## Performance Characteristics

### Computation Time
- **2×2 matrices**: 2 clock cycles + overhead
- **4×4 matrices**: 4 clock cycles + overhead  
- **6×6 matrices**: 6 clock cycles + overhead
- **8×8 matrices**: 8 clock cycles + overhead

### Resource Utilization
- **2×2**: 4 MAC units
- **4×4**: 16 MAC units
- **6×6**: 36 MAC units  
- **8×8**: 64 MAC units
- **Total**: 120 MAC units maximum

## Simulation and Testing

### Running the Testbench
```bash
# Compile all Verilog files
iverilog -o matrix_sim *.v

# Run simulation  
vvp matrix_sim

# View waveforms (if VCD dumping enabled)
gtkwave matrix_sim.vcd
```

### Test Cases Included
1. **2×2 Matrix Test**: Verifies basic functionality with known values
2. **4×4 Matrix Test**: Tests larger matrix computation
3. **Timing Verification**: Ensures proper state machine operation
4. **Memory Interface Test**: Validates read/write operations

## Design Features

### Scalability
- Modular design allows easy addition of larger matrix sizes
- Parameterized data widths
- Configurable maximum matrix size

### Power Efficiency  
- Only required PE arrays are enabled during computation
- Automatic power-down of unused units
- Clock gating opportunities in each PE

### Error Handling
- Overflow protection with extended precision accumulators
- Reset functionality for clean startup
- Valid signal propagation

### Interface Flexibility
- Standard memory-mapped interface
- Configurable addressing scheme
- Status monitoring capabilities

## Future Enhancements

1. **Pipeline Optimization**: Implement systolic array data flow
2. **Floating Point Support**: Add IEEE 754 compatibility  
3. **Sparse Matrix Support**: Optimize for sparse input matrices
4. **Multi-precision**: Support for 8-bit, 32-bit data types
5. **Error Correction**: Add ECC for memory reliability

## File Structure

```
MiniGPU/
├── mac_unit.v              # Basic MAC functionality
├── processing_element.v    # PE wrapper with MAC
├── matrix_mult_2x2.v      # 2x2 matrix multiplier
├── matrix_mult_4x4.v      # 4x4 matrix multiplier  
├── matrix_mult_6x6.v      # 6x6 matrix multiplier
├── matrix_mult_8x8.v      # 8x8 matrix multiplier
├── memory_controller.v     # Memory management
├── matrix_scheduler.v      # Computation coordination
├── matrix_accelerator.v    # Top-level integration
├── tb_matrix_accelerator.v # Comprehensive testbench
└── README.md              # This documentation
```

## Contact and Support

This design provides a complete matrix multiplication accelerator suitable for FPGA implementation or ASIC design. The modular architecture allows for easy customization and optimization based on specific requirements.# MiniGPU
