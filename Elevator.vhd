library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Abhay_elevator is  
    Port ( 
        clk          : in  std_logic;
        reset        : in  std_logic;
        call_floor   : in  std_logic_vector(2 downto 0);
        call         : in  std_logic;
        door_open    : out std_logic;
        current_floor: out std_logic_vector(2 downto 0);   
         door_message : out STD_LOGIC_VECTOR(71 downto 0)
       
    );
end Abhay_elevator;

architecture Behavioral of Abhay_elevator is
    type state_type is (IDLE, MOVE_UP, MOVE_DOWN, OPEN_DOOR);
  
    constant message :std_logic_vector(71 downto 0) := x"44_4F_4F_52_20_4F_50_45_4E"; 
    

  
    
    signal current_state, next_state : state_type;
    signal floor_count : unsigned(2 downto 0);
    constant counter:time:=15ns;
begin

    -- Clock and floor counter process
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
            floor_count <= (others => '0');
          
        
        elsif rising_edge(clk) then
            current_state <= next_state;
            
            case next_state is
                when MOVE_UP =>
                    if floor_count < 7 then  -- Max floor is 7
                        floor_count <= floor_count + 1;
                    end if;
                 
                     

                when MOVE_DOWN =>
                    if floor_count > 0 then
                        floor_count <= floor_count - 1;
                        
                    end if;
                when others =>
            
                       null;
                       
            end case;
        end if;
    end process;

    -- FSM next-state logic and output
    process(call_floor, current_state, floor_count, call)
    begin
        next_state <= current_state;
        door_open<='0';
        door_message<=(others=>'0');

        case current_state is
            when IDLE =>
                if call = '1' then
                    if unsigned(call_floor) > floor_count then
                        next_state <= MOVE_UP;
                    elsif unsigned(call_floor) < floor_count then
                        next_state <= MOVE_DOWN;
                    else
                       
                        next_state <= OPEN_DOOR;
                       -- same floor
                    end if;
                end if;

            when MOVE_UP =>
                if unsigned(call_floor) = floor_count then
                  
                    next_state <= OPEN_DOOR;
                else
                    next_state <= MOVE_UP;
                end if;

            when MOVE_DOWN =>
                if unsigned(call_floor) = floor_count then
                  
                    next_state <= OPEN_DOOR;
                else
                    next_state <= MOVE_DOWN;
                end if;

            when OPEN_DOOR =>
               door_open<='1';
               door_message<=message;
                next_state <= IDLE;
               
            when others =>
                next_state <= IDLE;
        end case;
    end process;

    current_floor <= std_logic_vector(floor_count);

end Behavioral;
