# SSDF Attacks in ElectroSense

This repository contains the modified ElectroSense source code used in the bachelor thesis "Implementation and Detection of Spectrum Data Falsification Attacks Affecting Crowdsensing Platforms".
The official sensing software can be found in the repository from ElectroSense (https://github.com/electrosense/es-sensor).


## Installation guide

* Install the following packages

```
$  sudo apt install git-core cmake librtlsdr-dev librtlsdr0 libliquid1d libliquid-dev liblzma-dev liblzma5 libusb-1.0-0-dev fftw-dev libssl-dev libjson-c3 libjson-c-dev zlib1g-dev zlib1g perf
```

* Clone the repository into the Raspberry PI
```
$ git clone https://github.com/RobinWassink/BT_SSDF_Attacks.git

```

* Run the start script, which takes care of compiling, copying to the designated folder and starting the process. You might need to give it the permission with chmod. 
```
cd BT_SSDF_Attacks
./attacks/run.sh

```

To start the monitoring, follow these steps:

* Adjust the parameters for the desired monitoring process:
    * Time duration(s) of a sample in attacks/start_monitor.sh line 5: for time in {TIME1} {TIME2} ...
    * Attack bandwidth in attacks/start_monitor.sh line 7: for bandwidth in {BANDWIDTH1} {BANDWIDTH2} ...
    * Amount of samples in attacks/monitor.sh line 5: total_loop={SAMPLES}

* Make sure there's enough space in the /data folder !

* Run the monitoring script
```
./attacks/start_monitor.sh

```
* It is recommended to run the monitoring script to be run with the `screen` command so it doesn't block the terminal and runs even when the ssh connection to the PI is lost. 
```
screen ./attacks/start_monitor.sh

```
Remember to start loggin by pressing CTR-a + H after starting. 

## Main modified files:

* drivers/rtlsdr/rtlsdrDriver.cpp: Seven SSDF Attacks added. 
* drivers/rtlsdr/rtlsdrDriver.h: Seven SSDF Attacks added. 
* ProcessingBlocks/FFT.cpp: Seven SSDF Attacks added. 
* ProcessingBlocks/FFT.h: Seven SSDF Attacks added. 
* main.cpp: Added mode, attacking bandwidth and affected frequencies to parse_args()
* context/ElectrosenseContext.cpp: Added variables supporting the main.cpp change
* context/ElectrosenseContext.h: Added variables supporting the main.cpp change
