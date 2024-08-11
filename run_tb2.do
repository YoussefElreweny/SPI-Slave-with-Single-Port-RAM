vlib work
vlog ram.v spi2.v project_tb2.v project_tb.v
vsim -voptargs=+acc work.project_tb
add wave *
add wave -position insertpoint  \
sim:/project_tb/pr/spi/rx_data \
sim:/project_tb/pr/spi/shift_reg \
sim:/project_tb/pr/spi/bit_cnt
add wave -position insertpoint  \
sim:/project_tb/pr/m1/mem
add wave -position insertpoint  \
sim:/project_tb/pr/m1/tx_valid
add wave -position insertpoint  \
sim:/project_tb/pr/spi/cs \
sim:/project_tb/pr/spi/ns
add wave -position insertpoint  \
sim:/project_tb/pr/spi/finished_read_flag \
sim:/project_tb/pr/spi/read_data_or_addr
add wave -position insertpoint  \
sim:/project_tb/pr/spi/tx_data
add wave -position insertpoint  \
sim:/project_tb/pr/spi/miso
add wave -position insertpoint  \
sim:/project_tb/pr/spi/tx_bit_cnt
run -all
#quit -sim