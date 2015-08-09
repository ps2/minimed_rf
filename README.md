# minimed_rf

Many Medtronic insulin pumps are capable of sending CGM data to a remote monitor called MySentry.  This project provides ruby libraries and tools to decode the message sent between the devices.  To capture and send packets, you can use something like [RileyLink](https://github.com/ps2/rileylink) or an SDR. 

## rf modulation

The frequency used is 916.7MHz, and the modulation is ASK/OOK. Data rate is 16kBaud. I use an RX filter BW of 203kHz since the pump, sensor, and mysentry all use different antennas and the frequency varies a bit from the center. 

Here are the settings I use to configure a cc1110:

```
/* RF settings SoC: CC1110 */
SYNC1     = 0xFF; // sync word, high byte 
SYNC0     = 0x00; // sync word, low byte 
PKTLEN    = 0x0E; // packet length 
PKTCTRL0  = 0x00; // packet automation control 
CHANNR    = 0x02; // channel number 
FSCTRL1   = 0x06; // frequency synthesizer control 
FREQ2     = 0x23; // frequency control word, high byte 
FREQ1     = 0x40; // frequency control word, middle byte 
FREQ0     = 0x00; // frequency control word, low byte 
MDMCFG4   = 0x89; // modem configuration 
MDMCFG3   = 0x4A; // modem configuration 
MDMCFG2   = 0x33; // modem configuration 
MDMCFG1   = 0x12; // modem configuration 
MDMCFG0   = 0x3B; // modem configuration 
DEVIATN   = 0x15; // modem deviation setting 
MCSM0     = 0x18; // main radio control state machine configuration 
FOCCFG    = 0x17; // frequency offset compensation configuration 
FREND0    = 0x11; // front end tx configuration 
FSCAL3    = 0xE9; // frequency synthesizer calibration 
FSCAL2    = 0x2A; // frequency synthesizer calibration 
FSCAL1    = 0x00; // frequency synthesizer calibration 
FSCAL0    = 0x1F; // frequency synthesizer calibration 
TEST1     = 0x31; // various test settings 
TEST0     = 0x09; // various test settings 
PA_TABLE1 = 0x8E; // pa power setting 1 
VERSION   = 0x04; // chip id[7:0] 
```

## data encoding

The data is encoded using an odd 6-bit code to 4-bit hex character encoding. This took me a long time to work out. I couldn't find anything like it out there. Someone let me know if there is a name for this kind of encoding.

```ruby
    "010101" => "0",
    "110001" => "1",
    "110010" => "2",
    "100011" => "3",
    "110100" => "4",
    "100101" => "5",
    "100110" => "6",
    "010110" => "7",
    "011010" => "8",
    "011001" => "9",
    "101010" => "a",
    "001011" => "b",
    "101100" => "c",
    "001101" => "d",
    "001110" => "e",
    "011100" => "f"
```

A raw (encoded) packet looks something like this:
```
ab29595959655743a5d31c7254ec4b54e55a54b555d0dd0e5555716aa563571566c9ac7258e565574555d1c55555555568bc7256c55554e55a54b55555556c55
```

Once you have decoded the data, the packets start to show some recognizeable fields:
```
a259705504e541120e1b0e080b004d4e00018a03010628127e0504004f0000008b120c000e080b00000c
```

a2 identifies the type of packet, 597055 is the pump number, etc...  The 0c at the end is an 8bit crc.

## usage

```
ruby -I lib bin/decode_minimed <packetdata>
```

## example

```
ruby -I lib bin/decode_minimed ab29595959655743a5d31c7254ec4b54e55a54b555d0dd0e5555716aa563571566c9ac7258e565574555d1c55555555568bc7256c55554e55a54b55555556c55
a2 597055 PumpStatus: #101 2014-08-11 18:14:00 -0500 - Glucose=154 PreviousGlucose=156 ActiveInsulin=1.975
```
