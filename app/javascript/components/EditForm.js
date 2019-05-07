
import React from "react"
import { map } from "lodash"
import { Form, Field } from "react-final-form";
import 'isomorphic-fetch';

import { incomeRows, customerDetailFields } from '../helpers/data'
import { getCSRF } from '../helpers/getCSRF';
import { SingleInput, RadioInput, TableInput } from './inputs'

const databaseURL = process.env.APP_URL  

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
        className="rebate-wrapper"
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
            <div className="flex-row">
              {map(customerDetailFields, (field) => {
                return field.type == 'radio'
                ? RadioInput(field)
                : SingleInput(field)
              })}
            </div>
            <div>
              <div className="flex-column">
                <h2 className="flex-item">Total Income</h2>
                <div className="flex-row">
                  <h2 className="flex-item one-third" >Income Type</h2>
                  <h2 className="flex-item one-third" >Applicant</h2>
                  <h2 className="flex-item one-third" >Partner</h2>
                </div>
                {map(incomeRows, (field) => {
                return (
                  <div key={field.id} className="flex-row">
                    <div className="flex-item one-third"> 
                      {field.label}
                    </div>
                    <div className="flex-item one-third">
                      {TableInput({...field, id: `${field.id}-Applicant`})}
                    </div>
                    <div className="flex-item one-third">
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

export default EditRebateForm
