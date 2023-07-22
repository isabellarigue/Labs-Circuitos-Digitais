USE ieee.std_logic_1164.all;

ENTITY fsm_seq IS

PORT (clock, reset, w : IN STD_LOGIC;
    z: OUT STD_LOGIC );

END fsm_seq;

ARCHITECTURE rtl OF fsm_seq IS

TYPE State_type IS (A, B, C, D, E); -- Tipo Enumerado

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
                            then y <= B;
                            else y <= E;
                        end if;
                    when B =>
                        if w = '1'
                            then y <= C;
                            else y <= B;
                        end if;
                    when C =>
                        if w = '0'
                            then y <= D;
                            else y <= A;
                        end if;
                    when D =>
                        if w = '1'
                            then y <= E;
                            else y <= B;
                        end if;
                    when E =>
                        if w = '0'
                            then y <= D;
                            else y <= A;
                        end if;
                end case;
            end if;
        end if;
    end process;
        z <= '1' when y = E else '0';
end rtl;
