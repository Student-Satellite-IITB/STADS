function [es_output] = es_main(sis_output, sm_output, ES_const, algo)
% Main function that runs the Estimation block

%% Code
    if algo == "Default Block"
        
        % You need to use sis_output not sis_input - fix this
        q = eul2quat([deg2rad(sis_output.attitude(1)),deg2rad(-sis_output.attitude(2)),deg2rad(-sis_output.attitude(3))],'ZYX');
        temp = q(1);
        q(1) = q(2);
        q(2) = q(3);
        q(3) = q(4);
        q(4) = temp;
        
        es_output.q_bi = q;
        es_output.status = "Done";

    elseif algo == "QUEST1"
        
        es_output.q_bi = es_quest_1(sm_output, ES_const);
        es_output.status = "Done";
        
    elseif algo == "QUEST2"
        
        es_output.q_bi = es_quest_2(sm_output, ES_const);
        es_output.status = "Done";
        
    elseif algo == "ESOQ2"
        
        es_output.q_bi = es_esoq2(sm_output, ES_const);       
        es_output.status = "Done";
    end
end
