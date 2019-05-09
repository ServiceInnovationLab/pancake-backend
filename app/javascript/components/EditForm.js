
import React from "react"
import { map } from "lodash"
import { Form, Field } from "react-final-form";
import arrayMutators from 'final-form-arrays'
import 'isomorphic-fetch';

import { customerDetailFields } from '../helpers/data'
import { getCSRF } from '../helpers/getCSRF';
import { calculator } from '../helpers/calculator_decorator';

import { SingleInput, RadioInput } from './inputs'
import { IncomeDeclaration } from "./IncomeDeclaration";

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
        decorators={[calculator]}
        mutators={{
          ...arrayMutators
        }}
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
        {({
          handleSubmit,
          submitting,
          values,
          form: {
            mutators:
             {
              push,
              pop
            }
          }
        }) => {
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
            {IncomeDeclaration()}
            <div className="buttons">
              <button
                type="button"
                onClick={() => push('fields.income.other_income', undefined)}
                >
                  Add Income Type
              </button>
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
