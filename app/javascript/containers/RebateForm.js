
import React, { Fragment } from 'react';
import { map, uniq, indexOf } from 'lodash';
import { Form, Field } from 'react-final-form';
import 'isomorphic-fetch';

import { conditionalsFields, customerDetailFields } from '../helpers/data';
import { requestBuilder } from '../helpers/requestBuilder';
import { calculator } from '../helpers/decorators';

import { SingleInput, RadioInput } from '../components/inputs';
import { IncomeDeclaration } from '../components/IncomeDeclaration';
import { parseFromAPI, prepareForAPI } from '../helpers/formatRebateForm';

const appUrl = window.location.origin;

class EditRebateForm extends React.Component {

  constructor(props) {
    super(props);

    const { rebateForm: { fields: {income} } } = this.props;

    const otherIncome = income && income.otherIncome;

    const applicantKeys = otherIncome && otherIncome.applicant ? Object.keys(otherIncome.applicant) : [];
    const partnerKeys = otherIncome && otherIncome.partner ? Object.keys(otherIncome.partner) : [];

    const uniqKeys = uniq(applicantKeys.concat(partnerKeys));
    this.state = { otherIncomeFields: uniqKeys };
  }

  addNewIncomeValue (values) {
    this.setState({otherIncomeFields: this.state.otherIncomeFields.concat(values.newIncomeField)});
    values.newIncomeField = null;
  }

  onSubmit (values) {
    const { council } = this.props; 
    const { fields } = values;

    const valuesForAPI = prepareForAPI(fields, council);

    return values.newIncomeField
      ? this.addNewIncomeValue(values)
      : requestBuilder({
        method: 'PATCH',
        path: `/admin/rebate_forms/${this.props.rebateForm.id}`,
        body: JSON.stringify(valuesForAPI)
      })
        .then(res => {
          console.log('res', res);
          if (res.ok) window.location = `${appUrl}/admin/rebate_forms/${this.props.rebateForm.id}`;
          else console.error(res);
        });
  }

  render () {
    const {
      rebateForm,
      property,
      ratesBills,
      isReadOnly
    } = this.props;

    const fields = parseFromAPI(rebateForm, property, ratesBills);

    const initialValues = {fields}; 

    const { otherIncomeFields } = this.state;

    return (
      <Form
        onSubmit={this.onSubmit.bind(this)}
        initialValues={initialValues}
        decorators={[calculator]}
      >
        {({
          handleSubmit,
          values,
        }) => {
          const includePartnerValues = values.fields.spouse_or_partner == 'yes';
          return (
            <form
              className="rebate-edit-form"
              onSubmit={handleSubmit}
            >
              <div className="flex-row">
                {map(customerDetailFields, (field, index) => {
                  if (indexOf([1, 4, 6, 8, 10, 12], index) >= 0) field.withMargin = true;
                  return field.type == 'radio'
                    ? RadioInput({...field, isReadOnly, values})
                    : SingleInput({...field, isReadOnly});
                })}
              </div>
              { values.fields.moved_within_rating_year == 'yes' &&
              <div className="flex-row">
                {map(conditionalsFields, (field, index) => {
                  if (indexOf([2, 4, 5], index) >= 0) field.withMargin = true;
                  return field.type == 'radio'
                    ? RadioInput({...field, isReadOnly, values})
                    : SingleInput({...field, isReadOnly});
                })}
              </div>
              }
              {IncomeDeclaration({otherIncomeFields, isReadOnly, includePartnerValues})}
              { !isReadOnly &&
              <Fragment>
                <div className={'flex-row'}>
                  <Field
                    className='rebate-search-input flex-item'
                    name="newIncomeField"
                    component="input"
                    readOnly={isReadOnly}
                  />
                  <button
                    className='one-third rebate-add-income-button'
                    disabled={isReadOnly || !values.newIncomeField}
                    type="button"
                    onClick={() => this.addNewIncomeValue(values)}
                  >
                      Add Income Type
                  </button>

                </div>
                <div className="rebate-submit-button-wrapper">
                  <button className="one-third rebate-add-income-button rebate-search-button" type="submit" >
                    Submit
                  </button>
                </div>
              </Fragment>
              }
            </form>
          );}}
      </Form>
    );
  }
}

export default EditRebateForm;
