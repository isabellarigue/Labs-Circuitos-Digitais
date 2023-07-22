USE ieee.std_logic_1164.all;

ENTITY fsm_table IS

PORT (clock, reset, w : IN STD_LOGIC;
    z: OUT STD_LOGIC );

END fsm_table;

ARCHITECTURE rtl OF fsm_table IS

TYPE State_type IS (A, B, C, D); -- Tipo Enumerado

SIGNAL y : State_type;

BEGIN
    process (clock)
    BEGIN
        if (clock'EVENT AND clock = '1') THEN
            if reset = '1' THEN -- A é o estado inicial nesse caso
                y <= A;
            else -- Caso reset = 0
                case y is
                    when A =>
                        if w = '0'
                            then y <= C;
                            else y <= B;
                        end if;
                    when B =>
                        if w = '0'
                            then y <= D;
                            else y <= C;
                        end if;
                    when C =>
                        if w = '0'
                            then y <= B;
                            else y <= C;
                        end if;
                    when D =>
                        if w = '0'
                            then y <= A;
                            else y <= C;
                        end if;
                end case;
            end if;
        end if;
    end process;

    process (y, w)
    begin
        case y is
            when A =>
                z <= '1';
            when B =>
                if w = '0'
                    then z <= '1';
                    else z <= '0';
                end if;
            when C =>
                z <= '0';
            when D =>
                if w = '0'
                    then z <= '0';
                    else z <= '1';
                end if;
        end case;
    end process;
end rtl;