
import React from "react"
import { map } from "lodash"
import { Form, Field } from "react-final-form";
import 'isomorphic-fetch';

import { conditionalsFields, customerDetailFields } from '../helpers/data'
import { getCSRF } from '../helpers/getCSRF';
import { calculator } from '../helpers/calculator_decorator';

import { SingleInput, RadioInput } from './inputs'
import { IncomeDeclaration } from "./IncomeDeclaration";

const databaseURL = process.env.APP_URL  

class EditRebateForm extends React.Component {

  constructor(props) {
    super(props);
    const { rebateForm: { fields } } = this.props
    this.state = { otherIncomeFields: fields.other_income }
  }

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
    const { otherIncomeFields } = this.state
    return (
      <Form
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
          return errors;
        }}
      >
        {({
          handleSubmit,
          submitting,
          values,
          form: {
            reset
          }
        }) => {
          return (
          <form
            className="rebate-edit-form"
            onSubmit={handleSubmit}
           >
            <div className="flex-row">
              {map(customerDetailFields, (field) => {
                return field.type == 'radio'
                ? RadioInput(field)
                : SingleInput(field)
              })}
            </div>
            { values.fields.moved_within_rating_year == 'yes'
            ? <div className="flex-row">
                {map(conditionalsFields, (field) => {
                return field.type == 'radio'
                ? RadioInput(field)
                : SingleInput(field)
                })}
              </div>
              : null
            }
            {IncomeDeclaration({otherIncomeFields})}
            <div className={'flex-row'}>
              <label className='flex-item'>
                <h3>Additional Income Type: </h3>
              </label>
              <Field
                className='rebate-search-input flex-item'
                name="newIncomeField"
                component="input"
              />
            </div>
            <div className="buttons">
              <button
                disabled={!(values.newIncomeField)}
                type="button"
                onClick={() => {
                  this.setState({otherIncomeFields: { [values.newIncomeField]:0 , ...otherIncomeFields} })
                }}
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
