

% Compares manual mixed to manual complete image analysis methods for a
% subset of the images in the dataset


data_path = [get_dataset_path() '/Manual_Analysis/'];


first_csv_path = [data_path '/Manual_Pure/image_quantification.csv'];
second_csv_path = [data_path '/Manual_Mixed/image_quantification.csv'];


quantify_image_folder([data_path '/Manual_Pure/'])
quantify_image_folder([data_path '/Manual_Mixed/'])


ci_95 = compare_pair_of_quant_methods(first_csv_path,second_csv_path,'Manual','Mixed Manual');


