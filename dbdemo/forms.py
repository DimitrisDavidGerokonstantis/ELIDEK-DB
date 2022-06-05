from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField
from wtforms.validators import DataRequired

## when passed as a parameter to a template, an object of this class will be rendered as a regular HTML form
## with the additional restrictions specified for each field
class ResearcherForm(FlaskForm):
    res_id = StringField(label = "Researcher ID", validators = [DataRequired(message = "Researcher ID is a required field.")])

    first_name = StringField(label = "First Name", validators = [DataRequired(message = "First Name is a required field.")])

    last_name = StringField(label = "Last Name", validators = [DataRequired(message = "Last Name is a required field.")])

    gender = StringField(label = "Gender")

    birth_date = StringField(label = "Birth Date")

    org_name = StringField(label = "Organisation Name")

    submit = SubmitField("Create")


class EvaluationForm(FlaskForm):
    evaluation_id = StringField(label = "Evaluation ID", validators = [DataRequired(message = "Evaluation ID is not a required field.")])

    res_id = StringField(label = "Researcher ID", validators = [DataRequired(message = "Researcher ID is a required field.")])

    eval_date = StringField(label = "Evaluation Date")

    grade = StringField(label = "Grade")

    submit = SubmitField("Create")


class ProjectForm(FlaskForm):
    project_id = StringField(label = "Project ID", validators = [DataRequired(message = "Project ID is a required field.")])

    org_name = StringField(label = "Organisation's Name")

    title = StringField(label = "Title", validators = [DataRequired(message = "Title is a required field.")])

    summary = StringField(label = "Summary")

    grant_amount = StringField(label = "Grant Amount")

    starting_date = StringField(label = "Starting Date")

    ending_date = StringField(label = "Ending Date")

    evaluation_id = StringField(label = "Evaluation ID", validators = [DataRequired(message = "Evaluation ID is a required field.")])

    executive_id = StringField(label = "Executive ID", validators = [DataRequired(message = "Executive ID is a required field.")])

    program_id = StringField(label = "Program ID", validators = [DataRequired(message = "Program ID is a required field.")])

    submit = SubmitField("Create")


class ProgramForm(FlaskForm):
    program_id = StringField(label = "Program ID", validators = [DataRequired(message = "Program ID is a required field.")])

    prog_name = StringField(label = "Program Name")

    directorate = StringField(label = "Directorate", validators = [DataRequired(message = "Directorate is a required field.")])

    submit = SubmitField("Create")


class ExecutiveForm(FlaskForm):
    executive_id = StringField(label = "Executive ID", validators = [DataRequired(message = "Executive ID is a required field.")])

    first_name = StringField(label = "First Name", validators = [DataRequired(message = "First Name is a required field.")])

    last_name = StringField(label = "Last Name", validators = [DataRequired(message = "Last Name is a required field.")])

    submit = SubmitField("Create")


class WorksonForm(FlaskForm):
    workson_id = StringField(label = "Working Relations' ID", validators = [DataRequired(message = "Working Relations' is a required field.")])

    project_id = StringField(label = "Project ID", validators = [DataRequired(message = "Project ID is a required field.")])

    res_id = StringField(label = "Researcher ID", validators = [DataRequired(message = "Researcher ID is a required field.")])

    submit = SubmitField("Create")




class AdministratesForm(FlaskForm):
    project_id = StringField(label = "Project ID", validators = [DataRequired(message = "Project ID is a required field.")])

    res_id = StringField(label = "Researcher ID", validators = [DataRequired(message = "Researcher ID is a required field.")])

    submit = SubmitField("Create")
