from scipy.fftpack import fft
import numpy as np
import matplotlib.pyplot as plt
# Number of sample points
N = 10000
# sample spacing
T = 1.0 / 800.0
x = np.linspace(0.0, N*T, N)
y = np.random.randn(N)
yf = fft(y)
xf = np.linspace(0.0,1.0/(2.0*T),N/2)
# set Gaussian filter
alpha = 10
omega0 = 200 #hz
G = [np.exp(-alpha * np.power(float(omega-omega0)/omega0,2)) for omega in xf]
filtered = yf[0:N/2] * G

p1 = plt.plot(xf,2.0/N * np.abs( yf[0:N/2]),"red")
p2 = plt.plot(xf,2.0/N * np.abs( filtered),"blue")
plt.xlabel("Frequency (Hz)")
plt.ylabel("Amplitude")
plt.legend((p1[0],p2[0]),('Raw FFT Amp','Filtered FFT Amp'))
plt.savefig("Gaussian_filter.png",format="png")
