-------------------------------------------------------------------------------
--                                                                           --
--          X       X   XXXXXX    XXXXXX    XXXXXX    XXXXXX      X          --
--          XX     XX  X      X  X      X  X      X  X           XX          --
--          X X   X X  X         X      X  X      X  X          X X          --
--          X  X X  X  X         X      X  X      X  X         X  X          --
--          X   X   X  X          XXXXXX   X      X   XXXXXX      X          --
--          X       X  X         X      X  X      X         X     X          --
--          X       X  X         X      X  X      X         X     X          --
--          X       X  X      X  X      X  X      X         X     X          --
--          X       X   XXXXXX    XXXXXX    XXXXXX    XXXXXX      X          --
--                                                                           --
--                                                                           --
--                       O R E G A N O   S Y S T E M S                       --
--                                                                           --
--                            Design & Consulting                            --
--                                                                           --
-------------------------------------------------------------------------------
--                                                                           --
--         Web:           http://www.oregano.at/                             --
--                                                                           --
--         Contact:       mc8051@oregano.at                                  --
--                                                                           --
-------------------------------------------------------------------------------
--                                                                           --
--  MC8051 - VHDL 8051 Microcontroller IP Core                               --
--  Copyright (C) 2001 OREGANO SYSTEMS                                       --
--                                                                           --
--  This library is free software; you can redistribute it and/or            --
--  modify it under the terms of the GNU Lesser General Public               --
--  License as published by the Free Software Foundation; either             --
--  version 2.1 of the License, or (at your option) any later version.       --
--                                                                           --
--  This library is distributed in the hope that it will be useful,          --
--  but WITHOUT ANY WARRANTY; without even the implied warranty of           --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        --
--  Lesser General Public License for more details.                          --
--                                                                           --
--  Full details of the license can be found in the file LGPL.TXT.           --
--                                                                           --
--  You should have received a copy of the GNU Lesser General Public         --
--  License along with this library; if not, write to the Free Software      --
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA  --
--                                                                           --
-------------------------------------------------------------------------------
--
--
--         Author:                 Helmut Mayrhofer
--
--         Filename:               mc8051_top_struc.vhd
--
--         Date of Creation:       Mon Aug  9 12:14:48 1999
--
--         Version:                $Revision: 1.7 $
--
--         Date of Latest Version: $Date: 2002-01-07 12:17:45 $
--
--
--         Description: Connect the mc8051 core to its instruction and data
--                      memories.
--
--
--
--
-------------------------------------------------------------------------------
architecture struc of mc8051_top is

  signal s_rom_adr_sml:   std_logic_vector(11 downto 0);  -- new
  signal s_ramx_adr_sml:   std_logic_vector(10 downto 0);  -- new
    
  signal s_rom_adr:      std_logic_vector(15 downto 0);  -- Programmcounter =
                                                         -- ROM-adress
  signal s_rom_data:     std_logic_vector(7 downto 0);   -- data input from ROM
  signal s_ram_data_out: std_logic_vector(7 downto 0);   -- data output to
                                                         -- internal RAM
  signal s_ram_data_in:  std_logic_vector(7 downto 0);   -- data input from
                                                         -- internal RAM
  signal s_ram_adr:      std_logic_vector(6 downto 0);   -- internal RAM-adress
  signal s_ram_wr:       std_logic;                      -- read (0)/write (1)
                                                         -- internal RAM
  signal s_ram_en:       std_logic;                      -- RAM-block enable
  signal s_ramx_data_out: std_logic_vector(7 downto 0);  -- data output to
                                                         -- ext. RAM
  signal s_ramx_data_in:  std_logic_vector(7 downto 0);  -- data input from
                                                         -- ext. RAM
  signal s_ramx_adr:      std_logic_vector(15 downto 0); -- ext. RAM-adress
  signal s_ramx_wr:       std_logic;                     -- read (0)/write (1)
                                                         -- ext. RAM


begin                 -- architecture structural
	s_rom_adr_sml <= std_logic_vector(s_rom_adr(11 downto 0));  -- *** new    
	s_ramx_adr_sml <= std_logic_vector(s_ramx_adr(10 downto 0));  -- *** new    

  i_mc8051_core : mc8051_core
    port map(clk         => clk,
             reset       => reset,
             rom_data_i  => s_rom_data,
             ram_data_i  => s_ram_data_out,
             int0_i      => int0_i,
             int1_i      => int1_i,
             all_t0_i    => all_t0_i,
             all_t1_i    => all_t1_i,
             all_rxd_i   => all_rxd_i,
             p0_i        => p0_i,
             p1_i        => p1_i,
             p2_i        => p2_i,
             p3_i        => p3_i,
             p0_o        => p0_o,
             p1_o        => p1_o,
             p2_o        => p2_o,
             p3_o        => p3_o, 
             all_rxd_o   => all_rxd_o,
             all_txd_o   => all_txd_o,
             all_rxdwr_o => all_rxdwr_o,
             rom_adr_o   => s_rom_adr,
             ram_data_o  => s_ram_data_in,
             ram_adr_o   => s_ram_adr,
             ram_wr_o    => s_ram_wr,
             ram_en_o    => s_ram_en,
             datax_i     => s_ramx_data_in,
             datax_o     => s_ramx_data_out,
             adrx_o      => s_ramx_adr,
             wrx_o       => s_ramx_wr);
 
    
  -----------------------------------------------------------------------------
  -- Hook up the general purpose 128x8 synchronous on-chip RAM. 
  i_mc8051_ram : mc8051_ram     
	port map ( 
		clock		=> clk, 
		data		=> s_ram_data_in,     
		q			=> s_ram_data_out, 
		address		=> s_ram_adr,
		wren		=> s_ram_wr,
		clken		=> s_ram_en);

  -- THIS RAM IS A MUST HAVE!!
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Hook up the (up to) 64kx8 synchronous on-chip ROM.
	i_mc8051_rom : mc8051_rom
		port map (
			clock	=> clk,
			q		=> s_rom_data,
			address	=> s_rom_adr_sml);
  -- THE ROM OF COURSE IS A MUST HAVE, ALTHOUGH THE SIZE CAN BE SMALLER!!
  -----------------------------------------------------------------------------
  
    
  -----------------------------------------------------------------------------
  -- Hook up the (up to) 64kx8 synchronous RAM.
	i_mc8051_ramx : mc8051_ramx
		port map ( 
			clock	=> clk,
			data	=> s_ramx_data_out,
			q		=> s_ramx_data_in,
			address	=> s_ramx_adr_sml,
			wren	=> s_ramx_wr);
  -- THIS RAM (IF USED) CAN BE ON OR OFF CHIP, THE SIZE IS ARBITRARY.
  -----------------------------------------------------------------------------
  
end struc;
