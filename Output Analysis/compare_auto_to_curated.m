
data_path = [get_dataset_path() '\Temporal Datasets'];



comparison_method_to_groundtruth([data_path '/REAVER_hybrid_data_first_pass.xlsx'],...
    [data_path '/REAVER_program_automated_results.csv'])
saveas(gcf,[getappdata(0,'proj_path') '/temp/curation_negative_dataset.tif'])
close(gcf)


comparison_method_to_groundtruth([data_path '/REAVER_hybrid_data_third_pass.xlsx'],...
    [data_path '/REAVER_program_automated_results.csv'])
saveas(gcf,[getappdata(0,'proj_path') '/temp/curation_positive_dataset.tif'])
close(gcf)