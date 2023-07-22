USE ieee.std_logic_1164.all;

ENTITY fsm_diag IS

PORT (clock, reset, w : IN STD_LOGIC;
    z: OUT STD_LOGIC );

END fsm_diag;

ARCHITECTURE rtl OF fsm_diag IS

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
                            then y <= A;
                            else y <= B;
                        end if;
                    when B =>
                        if w = '0'
                            then y <= C;
                            else y <= B;
                        end if;
                    when C =>
                        if w = '0'
                            then y <= C;
                            else y <= D;
                        end if;
                    when D =>
                        if w = '0'
                            then y <= A;
                            else y <= D;
                        end if;
                end case;
            end if;
        end if;
    end process;
        z <= '1' when y = B else '0';
end rtl;