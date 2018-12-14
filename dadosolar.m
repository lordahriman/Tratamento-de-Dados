 
orig_dir = pwd;

cd('raw_data')

raw_files = ls;                         
raw_files = raw_files(3:end,:); 
n_raw = size(raw_files,1);

cd(orig_dir)

load('dataset.mat')
data_set_dates = ds.Properties.ObsNames;
n_data_set = size(data_set_dates,1);

for i=1:n_data_set
aux1 = strsplit(data_set_dates{i},' ');
data_set_dates_only(i) = datenum(aux1{1},'yyyy-mm-dd'); 

end

data_set_dates_only = data_set_dates_only';

%check if it is present in dataset

index_missing_file  = 0;

for i=1:n_raw
strname = strsplit(raw_files(i,:),'_');    
date = datenum(strname{2},'yyyymmdd');
check_dates = find(date == data_set_dates_only); 

if isempty(check_dates) 
     index_missing_file = [index_missing_file;i]; 
end

end

index_missing_file = index_missing_file(2:end);

missing_raw_files = raw_files(index_missing_file,:);



for i=1:size(missing_raw_files,1)


n_meas = 144;

file_string = sprintf('raw_data\\%s',missing_raw_files(i,:));

num = csvread(file_string,1,1);
new_ds = mat2dataset(num(1:n_meas,:)); 

fileID = fopen(file_string);
txt =  textscan(fileID,'%s %*[^\n]','Delimiter',',','HeaderLines',1); 
data_tag = txt{1}(1:n_meas);
new_ds.Properties.ObsNames = data_tag;
fclose(fileID);

new_ds.Properties.VarNames = {'Avg_windspeed_Anemometro','Max_windspeed_Anemometro','Min_windspeed_Anemometro','StdDev_windspeed_Anemometro','Count_windspeed_Anemometro'...
                           'Avg_humidity_EE08','Max_humidity_EE08','Min_humidity_EE08','StdDev_humidity_EE08','Count_humidity_EE08'...
                           'Avg_temperature_EE08','Max_temperature_EE08','Min_temperature_EE08','StdDev_temperature_EE08','Count_temperature_EE08'...
                           'Avg_solarirradiance_Piranometro1','Max_solarirradiance_Piranometro1','Min_solarirradiance_Piranometro1','StdDev_solarirradiance_Piranometro1','Count_solarirradiance_Piranometro1'...
                           'Avg_solarirradiance_Piranometro2','Max_solarirradiance_Piranometro2','Min_solarirradiance_Piranometro2','StdDev_solarirradiance_Piranometro2','Count_solarirradiance_Piranometro2'...
                           'Avg_A1','Max_A1','Min_A1','StdDev_A1','Count_A1'...
                           'Avg_A2','Max_A2','Min_A2','StdDev_A2','Count_A2'...
                           'Avg_A3','Max_A3','Min_A3','StdDev_A3','Count_A3'...
                           'Avg_A4','Max_A4','Min_A4','StdDev_A4','Count_A4'...
                           'Avg_C1','Max_C1','Min_C1','StdDev_C1','Count_C1'...
                           'Avg_V','Max_V','Min_V'...
                           'Avg_I','Max_I','Min_I'...
                           'Avg_T','addr'};

           
ws = new_ds.Avg_windspeed_Anemometro;
ws_max = new_ds.Max_windspeed_Anemometro;
t = new_ds.Avg_temperature_EE08;
sol1 = new_ds.Avg_solarirradiance_Piranometro1;
sol2 = new_ds.Avg_solarirradiance_Piranometro2;
hum = new_ds.Avg_humidity_EE08;  

remove1 = find(ws < 0); 
remove2 = find(ws_max < 0);
remove3 = find(t < -15);
remove4 = find(hum < 0);

remove5 = find(ws > 50);
remove6 = find(ws_max > 70); 
remove7 = find(t > 50);
remove8 = find(hum > 110);  

remove = sort([remove1;remove2;remove3;remove4;remove5;remove6;remove7;remove8]);
new_ds(remove,:)=[];

date_new_ds_string = strsplit(new_ds.Properties.ObsNames{1},' ');
date_new_ds = datenum(date_new_ds_string{1},'yyyy-mm-dd');

diff = data_set_dates_only - date_new_ds;
indexes = find(diff == min(diff));
index = indexes(end);




end
  