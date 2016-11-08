%% 内部パラメータの精度評価
%% 初期化
clear;clc;close all;

%% 内部パラメータを呼び出す
% 事前に Stereo Camera Calibrator 内部パラメータを推定しておく
load stereoParams.mat

%% 画像を読み込む
image_l = imread('image/left.png');
image_r = imread('image/right.png');

%% 歪みを補正する
undistort_l = undistortImage(image_l, stereoParams.CameraParameters1);
undistort_r = undistortImage(image_r, stereoParams.CameraParameters2);
[height,width,channel] = size(undistort_l);

%% グレースケールに変換
gray_l = rgb2gray(undistort_l);
gray_r = rgb2gray(undistort_r);

%% エッジを検出
edge_l = edge(gray_l,'sobel');
edge_r = edge(gray_r,'sobel');

%% ステレオマッチング
disparityRange = [16*5,16*20];
disparityMap = disparity(gray_l,gray_r,'DisparityRange',disparityRange);

%% 視差画像を表示
figure
imshow(disparityMap,disparityRange);
title('Disparity Map');
colormap jet
colorbar

%% 奥行きZの推定
%% 各値の設定
b = abs(stereoParams.TranslationOfCamera2(1,1));
fku = stereoParams.CameraParameters1.IntrinsicMatrix(1,1);
u0_l = stereoParams.CameraParameters1.PrincipalPoint(1,1);
u0_r = stereoParams.CameraParameters2.PrincipalPoint(1,1);
v0_l = stereoParams.CameraParameters1.PrincipalPoint(1,2);

%% 算出
X = (u0_l) * b ./ disparityMap;
Y = (v0_l) * b ./ disparityMap;
Z = fku * b ./ disparityMap ;

%% 奥行き画像を表示
ZRange = [0,1000];
figure
imshow(Z,ZRange);
title('Z Map');
colormap jet
colorbar
