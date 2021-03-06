datapoints = 40;

ds = zeros(length(datapoints),1);
for i = 2:datapoints
    ds(i) = 2*i - 1;
end

seconds = zeros(length(ds),1);
% secondsmu = zeros(length(ds),1);
secondsimp = zeros(length(ds),1);
secondsimp2 = zeros(length(ds),1);
firsts = zeros(length(ds),1);
quos = zeros(length(ds),1);
firstsums = zeros(length(ds),1);
secondsums = zeros(length(ds),1);
thirdsums = zeros(length(ds),1);
fourthsums = zeros(length(ds),1);
ms = zeros(length(ds),1);
approxs = zeros(length(ds),1);
% quos2 = zeros(length(ds),1);
% quos3 = zeros(length(ds),1);

for i = 1:length(ds)
    d = ds(i);
    m = (d-1)/2;

    D = roof(m-1,0);
    N = roof(m+1,2);
    Dp = Dp0(m);
    Np = Np0(m);
    N2p = N2p0(m);
    D2p = D2p0(m);
% 
    seconds(i) = 2*((N2p - factorial(d)*D2p)/(factorial(d)*D)) - (V1(m)*Dp/D);
%     secondsmu(i) = 2*(mu(m)/N) - (V1(m)*Dp/D);
    secondsimp(i) = (6*sig2sumovern(m)) - (V1(m)*DpoverD(m));
%     quos(i) = (secondsmu(i)/seconds(i));
%     quos2(i) = (secondsimp(i)/secondsmu(i));
    firsts(i) = 0.5*V1(m);
    
    % Try out the simplifications I got for the doubly indexed sums
    % First sum:
    firstsum = (1/3)*(((sqrt(pi)*gamma(m+3))/gamma(m+3/2))-4)-m;
    firstsums(i) = firstsum;
%     
    %firstsum = (3/2)*((sqrt(pi)*gamma(m+2)*(-4*(m+2)+(2*m+3)*harmonic(m+3/2)))/(2*gamma(m+5/2))+log(16));
    %firstsum = firstsum + (1/5)*((sqrt(pi)*(m+8)*gamma(m+3))/(gamma(m+3/2))-32);
    %firstsum = firstsum + (log(8)-6)*((sqrt(pi)*gamma(m+2))/(gamma(m+3/2))-2);
    %firstsum = firstsum -2*m;
    %firstsums(i) = firstsum;

    % Second sum:
    secondsum = 2*m^2/((2*m-1)*(2*m+1))-(2*m*sqrt(pi)*gamma(m))/((2*m-1)*(2*m+1)*gamma(m-0.5));
    secondsums(i) = secondsum;
    
    % Third sum:
    thirdsum = (m+1)/(2*m+1)-(sqrt(pi)*gamma(m+1))/((2*m+1)*gamma(m+0.5));
    thirdsums(i) = thirdsum;
    
    % Fourth sum:
    fourthsum = 0;
    for p1 = 2:m
        for p2 = (p1+1):(m-1)
            for q1 = 0:(p2-p1-1)
                fourthsum = fourthsum + (1/(2*p1-1))*kratio(p1+1,p1+q1)*(1/(2*p2-1))*kratio(p2+1,m+1);
            end
        end
    end
    fourthsums(i) = fourthsum;

    %Dsum:
    %dsum = V1(m)*((m+1)-(2^(2*m)*(factorial(m))^2)/(factorial(2*m)));
    dsum = V1(m)*((m+1)-(sqrt(pi)*gamma(m+1)/gamma(m+1/2)));
    
    secondsimp2(i) = 6*(firstsum + secondsum + thirdsum + 0) - dsum;
    
    ms(i) = m;
    
    approx = 0.5*(V1(m))^2+V1(m)*((3*(m-1))/(2*m+1)) - ((2*(12*m^3+4*m^2-6*m-1))/((2*m-1)*(2*m+1)));
    approxs(i) = approx;
    
    quos(i) = secondsimp2(i)/approxs(i);
end

figure(1);
plot(ds, firsts, 'ro');
hold on;
%plot(ds, fourthsums, 'bo');
%plot(ds, ds, 'k-');
plot(ds, seconds, 'bo');
%plot(ds, secondsimp, 'g.');
plot(ds, secondsimp2, 'k.');
plot(ds, approxs, 'go');
plot(ds, 6*fourthsum, 'co');
hold off;
legend('First Order Term', 'Second Order Term', 'Approximation', 'Fourthsum', 'Location', 'NorthWest');
set(gca, 'FontSize', 15);
%legend('Firsts', 'Line', 'Seconds', 'Secondsmu', 'Secondsimp', 'Secondsimp2', 'Location', 'NorthWest');

% plot(ds, secondsimp, 'b--o');
% xlabel('Dimension d');
% ylabel('Second order term');
% title('Second order term vs. Dimension');
% set(gca, 'FontSize', 15);