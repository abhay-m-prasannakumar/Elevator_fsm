library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Abhay_elevator is
end entity;

architecture sim of tb_Abhay_elevator is

    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal call_floor    : std_logic_vector(2 downto 0) := (others => '0');
    signal call          : std_logic := '0';
    signal door_open     : std_logic;
    signal current_floor : std_logic_vector(2 downto 0);
    signal door_message  : std_logic_vector(71 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the design under test (DUT)
    uut: entity work.Abhay_elevator
        port map (
            clk => clk,
            reset => reset,
            call_floor => call_floor,
            call => call,
            door_open => door_open,
            current_floor => current_floor,
            door_message => door_message
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Apply reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- Initially at floor 0, call floor 2 → elevator should move up
        call_floor <= "011";  -- floor 2
        call <= '1';
        wait for 20 ns;
        call <= '0';

        -- Wait long enough for elevator to reach floor 2 and open door
        wait for 40 ns;

        -- Now call floor 0 → elevator should move down
        call_floor <= "000";  -- floor 0
        call <= '1';
        wait for 20 ns;
        call <= '0';

        -- Wait long enough for elevator to reach floor 0 and open door
        wait for 40 ns;

        -- Call floor 1 → elevator moves up by 1 floor
        call_floor <= "001";  -- floor 1
        call <= '1';
        wait for 20 ns;
        call <= '0';

        wait for 40 ns;

        -- End simulation
        wait;
    end process;

end architecture;
