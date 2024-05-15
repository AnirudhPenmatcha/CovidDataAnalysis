Here is an analysis performed on the information available for Covid from [ourworldindata.org](https://ourworldindata.org/covid-deaths)

The data was first prepared in **Excel**, then cleaned and processed in **SQL**, and finally visualized in **Tableau**. 

1. For the preparation, two datasets were created with the help of Excel. One was mainly about the death and infection count and the other vacciation count. Both were exported as CSVs.
The datasets were decently large both at size of approximately 400,000 records. 

2. With the data prepared, next was to import it into MySQL. Attempt was made to import it directly into MySQL, however, using a GUI tool seemed to be the better option. MySQL workbench
was the first choice. But it was slow in importing the large data size. Finally, dbeaver-ce worked effeciently with flexibility on several levels from importing to how the results are shown.

3. Several [commands](https://github.com/AnirudhPenmatcha/CovidDataAnalysis/blob/main/CovidData.sql) in SQL were written to analyse and indentify interesting relationships and insights.
Complex SQL functions such as CTEs, TempTables and joins were used to name a few.

4. Finally, these commands were then selectively picked based on what could be especially valuable to visualize. The results of these queries were exported as CSVs, opened in excel,
imported into Tableau Public and experimented with various options and visualization options for adding into the final dashboard. Two dashboards were created at the end. Both are uploaded
to Tableau public to view. One's for death and infection counts visualized and the other for numbers associated with hospitals such as number of vaccinations being administered, number of
new ICU patients coming in daily, and also the effect of Covid on the reproduction rates. 

![Dashboard 1](https://github.com/AnirudhPenmatcha/CovidDataAnalysis/assets/53865153/1b998a23-22ec-4e7b-a725-3d92afc69b3e)
[Link to 1st Dashboard](https://public.tableau.com/views/CovidDashboard_17157168228460/Dashboard1?:language=en-US&:sid=&:display_count=n&:origin=viz_share_link)

![Dashboard 2](https://github.com/AnirudhPenmatcha/CovidDataAnalysis/assets/53865153/65fa6870-946a-4ef6-af27-4b944f0c3899)
[Link to 2nd Dashboard](https://public.tableau.com/views/CovidDashboard2_17157305622110/Dashboard2?:language=en-US&:sid=&:display_count=n&:origin=viz_share_link)

\
\
**Citing the dataset used:**

@article{owidcoronavirus,\
    author = {Edouard Mathieu and Hannah Ritchie and Lucas Rodés-Guirao and Cameron Appel and Charlie Giattino and Joe Hasell and Bobbie Macdonald and Saloni Dattani and Diana Beltekian and Esteban Ortiz-Ospina and Max Roser},\
    title = {Coronavirus Pandemic (COVID-19)},\
    journal = {Our World in Data},\
    year = {2020},\
    note = {https://ourworldindata.org/coronavirus}\
}
