function [ evSys, busses ] = setupEVsystems(randomPlacement, num, sBase, vBase, onPU, busInt, sMaxInt, pRatedInt, pRateInt, eRatedInt,Ts)
%setupEVsystems returns a set of EV system structs. 
%   Setup a portfolio of EV systems. The EV systems could be placed in
%   e.g., a low voltage distribution grid. This function relies on the
%   class evAsset. The class evAsset implements a single P,Q controllable
%   EV charging system dependant on a stochastic vehicle at house
%   availability model.
%
%   The systems are randomly constructed according to the intervals given
%   by the inputs described below. 
%
% Inputs:
%   - randomPlacement [-], is a flag describing if the placement of EV
%     systems on the busses, should be random based on the busInt input or
%     if the busInt describes exactly which busses the PV systems should be
%     placed.
%   - num [-], is the number of EV systems wanted.
%   - sBase [VA], is the complex power base of the grid studiet (Only used when simulating on a per unit basis).
%   - vBase [V], is the voltage base of the grid studiet.
%   - onPU [-], indicates if the system is simulated on a per unit basis.
%   - busInt [-], is the interval of busses the EV systems can be placed
%     on, e.g., [2 30] means that the systems can be placed on bus 2 to 30.
%     If the systems are not to be placed randomly this input describes the
%     exact placement of EV systems, i.e., busInt = [2 3 15 34 ...]. Thus,
%     length(busInt) = num.
%   - sMaxInt [VA], is the apparent power interval, e.g., [6e3 11e3].
%   - pRatedInt [W], is the rated power interval, e.g., [6e3 11e3].
%   - areaInt [m^2], is the solar panel area interval, e.g., [20 25].
%   - efficiencyInt [-], efficiency interval, typically [0.18 0.25].
%   - Ts [sec], sampling time.
%
% Outputs:
%   - evSys [struct of structs], object containing the PV systems structs.
%   - busses [-], a ordered list describing which busses the PV systems are
%     placed. That is: pvSys(1) is placed on busses(1) and so forth. Note:
%     busses(1) might be any number in the busInt,
%     i.e., busses(1) = 42, if 42 is in busInt.
%
% R. Pedersen, 6-2-2015, Aalborg University

% Error checking
if randomPlacement == false && length(busInt)~= num
    error('You have chosen to place the EV systems manually, but the number of busses specified in busInt does not match the number of busses specified in num.')
end

% Set parameter struct
param.sBase = sBase;
param.vBase = vBase;
param.Ts = Ts;

for i=1:num
    % Create parameter struct
    param.pRated = ceil(pRatedInt(1)+(pRatedInt(2)-pRatedInt(1))*rand(1));
    param.sMax = ceil(sMaxInt(1)+(sMaxInt(2)-sMaxInt(1))*rand(1));
    param.pRate = ceil(pRateInt(1)+(pRateInt(2)-pRateInt(1))*rand(1));
    param.eRated = eRatedInt(1)+(eRatedInt(2)-eRatedInt(1))*rand(1);
    param.onPU = onPU;
    if param.pRated > param.sMax
        temp = param.pRated;
        param.pRated = param.sMax;
        param.sMax = temp;
    end
    
    % Create PV system
    evSys(i) = evAsset(param);
end

% Place on busses
if randomPlacement == true
    busses = ceil(busInt(1)+(busInt(2)-busInt(1))*rand(num,1));
else
    busses = busInt;
end

end

