The AR and ARMA process models the statistics of a signal (variance ans spectrum) by shaping a white noise spectrum using a transfer function. Input to the LTI system is white noise with variance sigma and its output is a random process. In the ARMA process, we see the lags of the signal y[n] (Autoregressive of order N) equal to the lags of the white noise term w[n] (moving average of order M). The calculated coefficients of A(z) and B(z) are then used to estimate the PSD.

**AR_ARMA_Process.m** generates 1000 realizations of the broadband Autoregressive Moving Average (ARMA) process where coefficients for the transfer function H(z) are: \
                        A = [1 -1.3817 1.5632 -0.8843 0.4096]\
                        B = [1 0.3544 0.3508 0.1736 0.2401]\
 The program calculates the true PSD by finding H(z)^2, the periodogram over 1000 realizations, the ARMA and AR least-squares model, and the ARMA and AR Yule-Walker models. All PSD estimates are then plotted in amplitude and dB. 
 
 **AR_ARMA_Process1.m** generates 1000 realizations of the narrowband Autoregressive Movinga Average (ARMA) process where coefficients for the transfer function H(z) are:\
                        A = [1 -1.6408 2.2044 -1.4808 0.8145]\
                        B = [1 1.5857 0.9604] \
                        
**Gaussian_White_Noise.m** generates a random signal using matlabs randn function and finds the PSD estimate by Periodogram. The periodogram is averaged over 1000 realizations to reduce variance. The program also demonstrates the Probability Density Function (PDF) of the randn function.
