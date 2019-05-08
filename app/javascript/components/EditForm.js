
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
        'X-CSRF-Token': this.props.token || getCSRF(),
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        rebate_form: {...values}
      }),
      credentials: 'same-origin'
    }).then(res => {
      console.log(res)
    })
  }

  render () {
    const { 
      rebateForm,
      property,
      ratesBills
    } = this.props

    const { fields } = rebateForm
    const initialValues = {fields, ratesBills: ratesBills[0], property} 

    return (
      <Form
        className="rebate-wrapper"
        onSubmit={this.onSubmit.bind(this)}
        initialValues={initialValues}
        validate={values => {
          const errors = {};
          {map(initialValues, (value, key) => {
            if (!values[key]) {
              errors[key] = "Required";
            }
          })}
          // if (values.reception === "delivery") {
          //   if (!values.street) {
          //     errors.street = "Required";
          //   }
          // }
          return errors;
        }}
      >
        {({ handleSubmit, reset, submitting, pristine, values }) => (
          <form onSubmit={handleSubmit}>
            {console.log(values)}
            <div className="flex-row">
              {map(customerDetailFields, (field) => {
                return field.type == 'radio'
                ? RadioInput(field)
                : SingleInput(field)
              })}
            </div>
            <div>
              <div className="flex-column">
                <h2 className="flex-item">Income declaration (before tax)</h2>
                <h3> Total combined income before </h3>
                <div className="flex-row">
                  {map(['Income Type', 'Applicant', 'Partner'], title => (
                    <h2 key={title} className="flex-item one-third" >{title}</h2>
                  ))}
                </div>
                {map(incomeRows, (field) => {
                return (
                  <div key={field.id} className="flex-row">
                      <h3 className="flex-item one-third" >{field.label}</h3>
                      {TableInput({...field, id: `applicant.${field.id}`})}
                      {TableInput({...field, id: `partner.${field.id}`})}
                  </div>
                )
                })}
              </div>
            </div>
            <div className="buttons">
              <button type="submit" disabled={submitting}>
                Submit
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
