function varargout = BNSMatlabSDK_GUI(varargin)
% BNSMATLABSDK_GUI M-file for BNSMatlabSDK_GUI.fig
%      BNSMATLABSDK_GUI, by itself, creates a new BNSMATLABSDK_GUI or raises the existing
%      singleton*.
%
%      H = BNSMATLABSDK_GUI returns the handle to a new BNSMATLABSDK_GUI or the handle to
%      the existing singleton*.
%
%      BNSMATLABSDK_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BNSMATLABSDK_GUI.M with the given input arguments.
%
%      BNSMATLABSDK_GUI('Property','Value',...) creates a new BNSMATLABSDK_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BNSMatlabSDK_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BNSMatlabSDK_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BNSMatlabSDK_GUI

% Last Modified by GUIDE v2.5 29-Sep-2006 09:19:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BNSMatlabSDK_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BNSMatlabSDK_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes during object creation, after setting all properties.
%DO NOT DELETE THIS (even though the function seemingly does nothing)
%- OR BAD THINGS WILL HAPPEN!!
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.


% --- Executes just before BNSMatlabSDK_GUI is made visible.
function BNSMatlabSDK_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BNSMatlabSDK_GUI (see VARARGIN)

%Call the constructor, open a handle to the hardware
BNS_OpenSLM();

%Read the LUT file that we will process the data through and the 
%SLM backplane calibration file
handles.slm_lut = BNS_ReadLUTFile('C:\BNSMatlabSDK\LUT_Files\linear.LUT');
handles.optimization_data = imread('C:\BNSMatlabSDK\Image_Files\blank.bmp','bmp');

%Initalize that we are not applying our phase optimization
handles.apply_optimization = false;

%Initalize a timer to be used later for sequencing
handles.TIMER = timer;
set(handles.TIMER, 'TimerFcn', {@OnTimer_Callback, handles});
set(handles.TIMER, 'Period',1);  % set the timer to run once per second
set(handles.TIMER, 'ExecutionMode','fixedRate');     % set the timer to run repeatedly

%Load a series of images to the hardware memory - we will sequence
%through these images later when the start/stop button is clicked
for pattern = 0:6  
    %Read in an image - zernike patterns in this case
	ImageData = Get512Zernike(pattern);  
    % Load the image to a frame in memory on the PCI card
	BNS_LoadImageFrame(pattern, ImageData, handles); 
end
%Initalize that we loaded 7 images to the PCI card hardware
handles.num_images = 7;

%clean up - now that the data is loaded to the PCI memory we don't need it
%anymore
clear ImageData;

%Initalize the data on the SLM to be the first pattern
BNS_SendImageFrameToSLM(0);

% Choose default command line output for BNSMatlabSDK_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BNSMatlabSDK_GUI wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BNSMatlabSDK_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BNS_CloseSLM();
%clean up the timer allocation
delete(handles.TIMER);
        
% Hint: delete(hObject) closes the figure
delete(hObject);

% --- Executes on button press in SLMPowerButton.
function SLMPowerButton_Callback(hObject, eventdata, handles)
% hObject    handle to SLMPowerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SLMPowerButton
bSLMPower = get(hObject,'Value');
BNS_SetPower(bSLMPower);

% --- Executes on selection change in ImageListbox.
function ImageListbox_Callback(hObject, eventdata, handles)
% hObject    handle to ImageListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ImageListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ImageListbox

%Send our currently selected image from the PCI card memory out to the SLM
SelectedImage = get(hObject,'Value');
%make it a zero based number
SelectedImage = SelectedImage - 1;
BNS_SendImageFrameToSLM(SelectedImage);

% --- Executes during object creation, after setting all properties.
%DO NOT DELETE THIS (even though the function seemingly does nothing)
%- OR BAD THINGS WILL HAPPEN!!
function ImageListbox_CreateFcn(hObject, eventdata, handles)
%function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImageListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

% --- Executes on button press in ApplyOptimizationCheckbox.
function ApplyOptimizationCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to ApplyOptimizationCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ApplyOptimizationCheckbox
handles.apply_optimization = get(hObject,'Value');

% Update handles structure
guidata(hObject, handles);

%If the optimization file was added or removed, then we need to reload the
%data to the PCI card. The number of images in this case doesn't change
%because we aren't editing the sequence. So I don't bother recounting the
%images here...
for pattern = 0:6  
    %Read in an image - zernike patterns in this case
	ImageData = Get512Zernike(pattern);  
    % Load the image to a frame in memory on the PCI card
	BNS_LoadImageFrame(pattern, ImageData, handles); 
end
%clean up - now that the data is loaded to the PCI memory we don't need it
%anymore
clear ImageData;

%Initalize the data on the SLM to be the first pattern
BNS_SendImageFrameToSLM(0);

%select the first row in the image listbox
set(handles.ImageListbox, 'Value', 1);


% --- Executes on button press in StartStopButton.
function StartStopButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartStopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bSeqRunning = get(hObject,'Value');
BNS_StartSequence(bSeqRunning, handles);
if(bSeqRunning)
    start(handles.TIMER);
else
    stop(handles.TIMER);
end

%Update the handles structure
guidata(hObject, handles);

function OnTimer_Callback(hObject, eventdata, handles)
%get the current image that is on the SLM
CurrentImage = BNS_GetRunStatus();
%adjust such that it isn't a zero based number
CurrentImage = CurrentImage + 1;
%select the current image in the image listbox
set(handles.ImageListbox, 'Value', CurrentImage);

%=============== BNS Functions =======================
%==========================================================================
%=   FUNCTION: ImageData = Get512Zernike(ZernikeNum)
%=
%=   PURPOSE: Generates a 512x512 matrix containing a Zernike phase
%=             pattern.  The pattern is scaled between the values of 
%=             0 and 255.
%=
%=   INPUTS:  Zernike Num - an integer in the range of 0-8 where 
%=              0 = PISTON
%=              1 = POWER
%=              2 = ASTIG X
%=              3 = ASTIG y
%=              4 = COMA X
%=              5 = COMA Y
%=              6 = PRIMARY SPHERICAL
%=
%=  OUTPUTS:  ImageData - a 512x512 array of integers in the range of 0..255.
%=
%==========================================================================
function ImageData = Get512Zernike(ZernikeNum)

ImageData = ones(512,512);
if     ZernikeNum == 0      % PISTON
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\BLANK.bmp','bmp');
elseif ZernikeNum == 1      % Power
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\Power.bmp','bmp');
elseif ZernikeNum == 2      % Astig X
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\AstigX.bmp','bmp');     
elseif ZernikeNum == 3      % Astig Y
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\AstigY.bmp','bmp'); 
elseif ZernikeNum == 4      % Coma X
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\ComaX.bmp','bmp');
elseif ZernikeNum == 5      % Coma Y
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\ComaY.bmp','bmp');
elseif ZernikeNum == 6      % Primary Spherical
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\PrimarySpherical.bmp','bmp'); 
end


%==========================================================================
%=   FUNCTION:  BNS_OpenSLM()
%=
%=   PURPOSE: Opens all the Boulder Nonlinear Systems SLM driver boards 
%=            in the system.  Assumes the devices are nematic (phase) 
%=            SLMs.  Loads the library "Interface.dll" into the MATLAB
%=            workspace.
%=            
%=   OUTPUTS: 
%=
%==========================================================================
function BNS_OpenSLM()
    % load the Interface dll to access the BNS functions
    loadlibrary('C:\BNSMatlabSDK\Interface.dll','C:\BNSMatlabSDK\Interface.h');
    
    % call the constructor passing the LC type, and the toggle rate
    % where LCType is 0 for Amplitude SLMs, and 1 for phase SLMs. The
    % toggle rate should be 6 for Phase SLMs, and is ignored for 
    % Amplitude SLMs (so it can also be 3)
    LCType = int32(1); 
    TrueFrames = int32(3); 
    calllib('Interface','Constructor',LCType, TrueFrames);

    % Set the download mode. Passing true will enable continuous download
    % mode, and passing false will disable continuous download mode. See
    % the manual for more information...
    calllib('Interface','SetDownloadMode', false); 
    
	% Set the run parameters. The first parameter is the FrameRate, 
    % which determines how fast the SLM will switch from one image to 
    % the next.  The second parameter is the LaserDuty, which determines 
    % the percentage of time that the laser is on. 
    % The third parameter is the TrueLaserGain which sets the voltage
	% of the laser output during the true viewing of the image. 
    % The last parameter is the InverseLaserGain which sets the voltage 
    % of the laser output during the inverse viewing of the image. 
    FrameRate = int32(1);    %number from 1 - 1000 (Hz)
    LaserDuty = int32(50);      %number from 0-100 (Percent laser on)
    TrueLaserGain = int32(255); %number from 0-255 
    InverseLaserGain = int32(0);%number from 0 - 255
    calllib('Interface','SetRunParam', FrameRate, LaserDuty, TrueLaserGain, InverseLaserGain);

%==========================================================================
%=   FUNCTION: LUT = BNS_ReadLUTFile(LUTFileName)
%=
%=   PURPOSE: Calls a C++ sub-function to read and return the LUT
%=
%=   INPUTS:  The LUT File Name
%=
%=  OUTPUTS:  LUT - a 256 element array of integers in the range of 0..255.
%=
%==========================================================================
function LUT = BNS_ReadLUTFile(LUTFileName)
    LUT = ones(256,1);
    pLUTData = libpointer('uint8Ptr', LUT);
    LUT = calllib('Interface','ReadLUTFile',pLUTData, LUTFileName);    

%==========================================================================
%=   FUNCTION: BNS_SetPower(bPower)
%=
%=   PURPOSE: Toggles the SLM power state
%=
%=   INPUTS:  a boolean state - true = power up, false = power down
%=
%=  OUTPUTS:  
%=
%==========================================================================        
function BNS_SetPower(bPower)
    calllib('Interface','SLMPower',bPower);         
    
%==========================================================================
%=   FUNCTION:   BNS_LoadImageFrame(ImageFrame,ImageMatrix)
%=
%=   PURPOSE:    Loads a image into a memory frame on the SLM driver board.
%=               WARNING - Loading the same memory frame that is currently
%=               being viewed on the SLM can result in corrupted images.  
%=             
%=   INPUTS:     ImageFrame - the memory frame being loaded (integer 0..1024) 
%=               ImageMatrix - A 512x512 matrix or 256x256 of integers, each 
%=                             within range 0..255, corresponding to the voltage
%=                             to be applied to the SLM pixel.
%=               ImageSize - if the image is bigger or smaller than the 
%=                           size of the SLM, then the lower level code
%=                           will scale the image appropriately
%=
%=   OUTPUTS:  
%=
%==========================================================================
function BNS_LoadImageFrame(ImageFrame, ImageMatrix, handles)
    %Add our phase optimization if selected, modulo 256
    if(handles.apply_optimization)
        ImageMatrix = mod(ImageMatrix + handles.optimization_data, 256);
    end;
    
    %increment the data up to 1 - 256 because Matlab isn't zero based
    ImageMatrix = ImageMatrix+1;
    
    % process the image through the LUT to remap the data such that
    % a linear phase response results
    for row=1:512
        for col=1:512
             ImageMatrix(row,col) = handles.slm_lut(ImageMatrix(row,col));
        end
    end
    
    % pass an array pointer down to the C++ code
    pImage = libpointer('uint8Ptr',ImageMatrix); 
    calllib('Interface','WriteFrameBuffer',ImageFrame, pImage, 512);

%==========================================================================
%=   FUNCTION:  BNS_SendImageFrameToSLM(ImageFrame)
%=
%=   PURPOSE:   Sends a new image (stored in a memory frame) out the SLM
%=              device for viewing.                    
%=
%=   INPUTS:    ImageFrame - the memory frame being loaded (integer 0..1022) 
%==========================================================================
function BNS_SendImageFrameToSLM(ImageFrame)
    calllib('Interface','SelectImage',ImageFrame);
    
%==========================================================================
%=   FUNCTION:  BNS_StartSequence(bStart)
%=
%=   PURPOSE:   Starts automatic sequencing                   
%=
%=   INPUTS:    bStart = true to start sequencing, or false to stop
%=              sequencing
%==========================================================================
function BNS_StartSequence(bStart, handles)
    %for this example assume image0 was loaded to frame0 in the PCI memory,
    %and image1 was loaded to frame1 and so on for each image in the
    %sequence. However, in reality the user does not need to sequentially
    %load the images to the PCI memory. In this case the user must keep
    %track of where the images are stored. For example: if the sequence
    %uses the same image twice it is not necessary to store the image in
    %the PCI card memory multiple times. In this case:
    % Image List    PCI Memory   FrameArray[seqNumber] = Frame
    % Image 0       Frame 0      FrameArray[0] = 0
    % Image 1       Frame 1      FrameArray[1] = 1
    % Image 2       Frame 0      FrameArray[2] = 0
    % Here Image0 and Image2 are the same image, so the FrameArray simply
    % references the same frame in the PCI card memory twice.
    FrameArray = [0,1,2,3,4,5,6];
    if(bStart)
        calllib('Interface', 'SetRunMode', 'Run', handles.num_images, FrameArray);
    else
        calllib('Interface', 'SetRunMode', 'Stop', handles.num_images,FrameArray);
    end
    
%==========================================================================
%=   FUNCTION: SeqNum = BNS_GetRunStatus
%=
%=   PURPOSE: Calls a C++ sub-function to return the current sequence
%             number that the hardware is on. Used to give the user
%             feedback while sequencing
%=   OUTPUTS: The current index of the image that the SLM is displaying
%=
%==========================================================================
function SeqNum = BNS_GetRunStatus()
    SeqNum = calllib('Interface', 'GetRunStatus');
    
%==========================================================================
%=   FUNCTION:  BNS_CloseSLM()
%=
%=   PURPOSE:   Closes the Boulder Nonlinear Systems SLM driver boards
%=              and unloads Interface.dll from the MATLAB Workspace
%==========================================================================
function BNS_CloseSLM()
   calllib('Interface','SLMPower', false);
   calllib('Interface','Deconstructor');
   unloadlibrary('Interface');








