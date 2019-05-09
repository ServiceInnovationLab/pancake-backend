
import React from "react"
import { reduce, map } from "lodash"
import { Form, Field } from "react-final-form";
import createDecorator from 'final-form-calculate'
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

const calculator = createDecorator(
  {
    field: /\w+/, // when a field matching this pattern changes...
    updates: {
      // ...update the total_income to the result of this function
      ['fields.income.total_income']: (newValue, allValues) => {
        const applicantValues = reduce(allValues.fields.income.applicant, (sum, value) =>
          sum + Number(value || 0), 0)
        const partnerValues = reduce(allValues.fields.income.partner, (sum, value) =>
          sum + Number(value || 0), 0)
        const total = applicantValues + partnerValues         
        return total
      }
    }
  }
)

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
        decorators={[calculator]}
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
        {({ handleSubmit, submitting, values }) => {
          return (
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
                <div className={'flex-row'}>
                  <label className='one-third'>
                    <h3>Total Combined Income: </h3>
                  </label>
                  <Field
                    className='rebate-search-input one-third'
                    name="fields.income.total_income"
                    component="input"
                    readOnly
                  />
                </div>
                <div className="flex-row">
                  {map(['Income Type', 'Applicant', 'Partner'], title => (
                    <h2 key={title} className="flex-item one-third" >{title}</h2>
                  ))}
                </div>
                {map(incomeRows, (field) => {
                return (
                  <div key={field.id} className="flex-row">
                      <label className="flex-item one-third">
                        <h3>{field.label}</h3>
                      </label>
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
        )}}
      </Form>
    );
  }
}

export default EditRebateForm
