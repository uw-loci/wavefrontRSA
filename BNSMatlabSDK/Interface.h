// Interface.h : main header file for the INTERFACE DLL
//

 extern "C" __declspec(dllexport) void Constructor(int LC_Type, int TrueFrames);
 extern "C" __declspec(dllexport) void Deconstructor();
 extern "C" __declspec(dllexport) void SetDownloadMode(bool ContinuousDownload);
 extern "C"	__declspec(dllexport) void SelectImage(int FrameNum);
 extern "C"	__declspec(dllexport) void SetRunMode(char *RunMode, int NumImages, unsigned short* FrameArray);
 extern "C"	__declspec(dllexport) void SetRunParam(int FrameRate, int LaserDuty, int TrueLaserGain, int InverseLaserGain);
 extern "C"	__declspec(dllexport) void SLMPower(bool PowerState);
 extern "C"	__declspec(dllexport) void WriteFrameBuffer(int FrameNum,  unsigned char *Image, int ImgSize);
 extern "C"	__declspec(dllexport) int  GetRunStatus();
 extern "C" __declspec(dllexport) void ReadLUTFile(unsigned char* LUT, char* LUTFile);

