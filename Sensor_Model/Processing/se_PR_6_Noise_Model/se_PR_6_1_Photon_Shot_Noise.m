function se_Image_Mat = se_PR_6_1_Photon_Shot_Noise(se_Image_Mat)
	% Photon Shot Noise for the Sensor Model
    %   This function applies the Photon Shot Noise into the Image Matrix
    %
    % -----------
    % References:
    % -----------
    %
    % Suppose that a distant star emits a stream of phtons in all
    % directions. These photons are emitted at random instants. When
    % looking at this value, the number of total phtons varies only
    % infinitesimally with time. However, by the time the photons reach our
    % sensor, they are only handful in number, and the relative
    % fluctuations in the number of photons is significant. These
    % fluctuations are captured by shot noise. 
    % For modelling shot noise, the number of phtons hitting the sensor is
    % modelled as a Poisson distribution with mean as the number of photons
    % that should have hit the pixel. So, we generate a Poisson Random
    % Variable with mean as the expected Pixel Value to get the actual
    % Pixel Value.
    %
    % Photon , Poisson noise - Samuel W. Hasinoff, Google Inc.
    % https://people.csail.mit.edu/hasinoff/pubs/hasinoff-photon-2012-preprint.pdf
    % https://www.uio.no/studier/emner/matnat/ifi/nedlagte-emner/INF5440/v10/undervisningsmateriale/F5e.pdf
    % https://camera.hamamatsu.com/jp/en/technical_guides/photon_shot_noise/index.html
    % https://svi.nl/PhotonNoise
    % https://en.wikipedia.org/wiki/Shot_noise
    %
    % -----------
    % Parameters:
    % -----------
    %
    % se_Image_Mat: (Array (1024, 1280))
    %   Image Matrix without Photon Shot Noise
    %   Comments:
    %   - Each pixel value is 10 Bits, i.e. 0 to 1023
    %
    % --------
    % Returns:
    % --------
    %
    % se_Image_Mat: (Array (1024, 1280))
    %   Updated Image Matrix containing Photon Shot Noise
    %   Comments:
    %   - Each pixel value is 10 Bits, i.e. 0 to 1023
    
    % =====
    % Code:
    % =====
    
    % Apply the Poisson Distribution
    se_Image_Mat = poissrnd(se_Image_Mat);
end

