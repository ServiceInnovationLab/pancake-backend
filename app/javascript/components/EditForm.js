
import React from "react"
import { map } from "lodash"
import { Form, Field } from "react-final-form";
import 'isomorphic-fetch';

import { getCSRF } from '../helpers/getCSRF';
const databaseURL = process.env.APP_URL  

const Error = ({ name }) => (
  <Field name={name} subscription={{ error: true, touched: true }}>
    {({ meta: { error, touched } }) =>
      error && touched ? <span>{error}</span> : null
    }
  </Field>
);

const Condition = ({ when, is, children }) => (
  <Field name={when} subscription={{ value: true }}>
    {({ input: { value } }) => (value === is ? children : null)}
  </Field>
);


class EditRebateForm extends React.Component {
  onSubmit (values) {
    fetch(`${databaseURL}admin/rebate_forms/1`, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': getCSRF(),
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        rebate_form: {fields: Object.assign({}, this.props.fields, values)}
      }),
      credentials: 'same-origin'
    }).then(res => {
      console.log(res)
    })
  }

  render () {
    const { fields } = this.props
    return (
      <Form
        onSubmit={this.onSubmit.bind(this)}
        initialValues={this.props.fields}
        validate={values => {
          const errors = {};
          {map(fields, (value, key) => {
            if (!values[key]) {
              errors[key] = "Required";
            }
          })}
          if (values.reception === "delivery") {
            if (!values.street) {
              errors.street = "Required";
            }
          }
          return errors;
        }}
      >
        {({ handleSubmit, reset, submitting, pristine, values }) => (
          <form onSubmit={handleSubmit}>
            {map(customerDetailFields, (field) => {
              return field.type == 'radio'
              ? RadioInput(field)
              : SingleInput(field)
            })}
            <div>
              <div className="flex-column">
                <h2 className="flex-item">Total Income</h2>
                <div className="flex-row">
                  <h2 className="flex-item" >Income Type</h2>
                  <h2 className="flex-item" >Applicant</h2>
                  <h2 className="flex-item" >Partner</h2>
                </div>
                {map(incomeRows, (field) => {
                return (
                  <div className="flex-row">
                    <div className="flex-item"> 
                      {field.label}
                    </div>
                    <div className="flex-item">
                      {TableInput({...field, id: `${field.id}-Applicant`})}
                    </div>
                    <div className="flex-item">
                      {TableInput({...field, id: `${field.id}-Partner`})}
                    </div>
                  </div>
                )
                })}
              </div>
            </div>
            <div className="buttons">
              <button type="submit" disabled={submitting}>
                Submit
              </button>
              <button type="button" onClick={reset} disabled={submitting}>
                Reset
              </button>
            </div>
            <pre>{JSON.stringify(values, 0, 2)}</pre>
          </form>
        )}
      </Form>
    );
  }
}

EditRebateForm.propTypes = {};

const incomeRows = [
  {
    id: "other_superannuation",
    label: "Other superannuation"
  },
  {
    id: "interest_dividends",
    label: "Interest / Dividends"
  },
  {
    id: "wages_salery",
    label: "Wages or Salary"
  }

]   
const customerDetailFields = [
  {
    id:"full_name",
    label: "Name",
  },
  {
    id:"customer_id",
    label: "Customer ID (optional)",
    placeholder: "0000000",
  },
  {
    id:"address",
    label: "Address",
    fullWidth: true
  },
  {
    id:"total_rates",
    label: "Total Rates",
  },
  {
    id:"valuation_id",
    label: "Valuation ID (optional)",
    placeholder: "00000 000 00",
  },
  {
    id: 'moved_within_rating_year',
    label: "Moved within rating year?",
    type:"radio"
  },
  {
    id: 'lived_in_property_1_July',
    label: "Lived in property 1 July 2018",
    type:"radio"
  },
  {
    id:"email",
    label: "Email",
    type:"email",
  },
  {
    id:"phone_number",
    label: "Phone",
    type:"tel",
  },
  {
    id: 'spouse_or_partner',
    label: "Spouse or Partner",
    type:"radio"
  },
  {
    id:"dependents",
    label: "Dependents",
    type:"number",
    placeholder: "0",
  },
  {
    id:"50%_claimed_expenses",
    label: "50% claimed as expenses?",
    type:"radio"
  },
  {
    id:"occupation",
    label: "Occupation",
  },
]

const SingleInput = ({ id, label, placeholder, type = "text" }) => {
  return (
  <div key={id} className=''>
    <label>{label}</label>
    <Field
      name={id}
      label= {label}
      placeholder= {placeholder}
      component='input'
      type={type}
    />
    <Error name={id} />
  </div>
)}
const TableInput = ({ id, label, placeholder, type = "text" }) => {
  return (
  <div key={id} className=''>
    <Field
      name={id}
      label= {label}
      placeholder= {placeholder}
      component='input'
      type={type}
    />
    <Error name={id} />
  </div>
)}

const RadioInput = ({ id, label, type }) => (
  <div key={id} >
    <label>{label}</label>
    <div>
      {map(["yes", "no"], value =>
      <label key={`${id}-${value}`} >
        <Field
          name={id}
          component="input"
          type={type}
          value={value}
        />{" "}
        {value}
      </label>
      )}
      <Error name={id} />
    </div>
  </div>
)
export default EditRebateForm
