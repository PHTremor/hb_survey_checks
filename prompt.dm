/plan create scripts that i can be using to check if data was added in the database or is missing, and how many records. The tables are in the schema.sql file.

The setups is like this:
qr_codes is the main table. The id is referenced by all other tables either as id if only one record is required or as survey_id if the table can hav multiple records for that qr_code.id

the setup is categorized into 13 modules/features:
module:tables (table names in the prompt might not be accurate, get actual names in schema.sql)

1. Administration: action_plans(1), business_plans(1), budgets(1), in_service_trainiing_plans(1), work_schedules(1), qi_plans(1), external_training_reports(1), attendance_registers(1), payables_registers(1), recievables_registers(1), annual_malaria_prevention_plans(1), customer_care_programs(1),
2. Data Management:MonthlyDataReports(1), DataManagementSOPs(1), DataAccuracies(8), CompletenessOfOPDRegisters(1), MaternalAndNeonatalHealths
3. Facility Perfomance Observation: FacilityPerfomanceObservation(>1)
4. Finance Management: ClosingBalances(1), Insurances(1), IncomeReviews(1), PharmacyStockValues(1), Accounts(1), TransactionExpenseReviews(3)
5. General Information: SurveyBasicInformations(1), OrganizationCharts(1), JobDescriptions(9), StaffInformations(1), FrequencyOfCommitteeMeetings(1), FocalPersons(1)
6. Patient Satisfaction: AdditionalSuggestions(15), InformationDeliveryAndSupportSatisfactions(15), PatientSatisfactionBasicInfos(15), PatientRightsAndResponsibilitiess(15), PatientArrivalPerceptions(15)
7. Pharmacy Management: PharmacyReviews(1), ExpiredDrugsManagements(1), AdditionalPharmacyInformations(1), DispensaryManagements(33), StockManagements(33),
8. Safety Management: SafetyManagement(1)
9. Sanitation: Sanitation(1)
10. Service Area Description:Ancs(1),Vaccinations(1),FamilyPlannings(1),PharmacyStocks(1),DispensingPharmacies(1),Ncds(1),Cehos(1),Cashiers(1),Accountings(1),Laboratories(1),Titualaires(1),DataManagers(1),Arvs(1),Receptionists(1),ConsultationRooms(1),Matenities(1),Hospitalizations(1),Toilets(1),NoticeBoards
11. Treatmement Guidelines Compliance: AncTreatmentGuidelines(15),AsthmaTreatmentGuidelines(15),CheckListTreatmentGuidelines(1),CoughTreatmentGuidelines(15),DiabetesTreatmentGuidelines(15),DiarrhoeaTreatmentGuidelines(15),FeverTreatmentGuidelines(15),HypertensionTreatmentGuidelines(15),InpatientsCareTreatmentGuidelines(15),MalariaTreatmentGuidelines(15),MaternityTreatmentGuidelines(1),PneumoniaTreatmentGuidelines(15),ReferralProcessTreatmentGuidelines(15),TreatmentGuidelines(1),DyslipidemiaTreatmentGuidelines(15),CardiomyopathyTreatmentGuidelines(15)
12. Treatment Outcomes: AdmittedPatientsOutcomes(15),AsthmaClassifications(15),HypertensionTreatmentOutcomes(15),DiarrhoeaKeyPerformanceIndicators(1),MalariaKeyPerformanceIndicators(1),MalnutritionKeyPerformanceIndicators(1),PneumoniaKeyPerformanceIndicators(1),DiabetesKnowledgeOnHomeSelfManagements(15),HypertensionKnowledgeOnHomeSelfManagements(15)
I also forgot to add these tables under treatment outcomes (add/replace): CardiomyopathyTreatmentOutcomes(1),HypertensionClearances,DiabetesClearances,NewDiabetesTreatmentOutcomes(15) --replaces DiabetesGlycemiaTreatmentOutcomes & DiabetesHba1cTreatmentOutcomes,DyslipidemiaTreatmentOutcomes(15),HypertensionNephropathyPrevalences(1),DiabetesNephropathyPrevalences(1)
13. Project Data: only check for these projects (from the projects table): 740d0859-5283-4912-9202-25a78d15f73a, a99a1242-3d9b-4346-89c4-1220f49b7a32 ... have to flezibility to add/select other projects....

The flow should allow to pick the district and survey year
Then display the missing or total count of added records for each feature, table, and health faculity/health center...
use either Python/Go and sql
Make sure you check the table if it has survey_id (FK) or just id (PK&FK)

I am not sure if it should either be a CLI tool or just scripts that can be run as in an ETL style, but just perfoming the check and generating a report of the added and missing

DB connection details are in .env. Connecting to the DB requires that the machine is connected via a VPN otherwise the connection fails.