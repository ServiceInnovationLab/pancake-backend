
import React, { Fragment } from 'react';
import { map, uniq, indexOf } from 'lodash';
import { Form, Field } from 'react-final-form';
import 'isomorphic-fetch';

import { conditionalsFields, customerDetailFields, income_less_than_5kField } from '../helpers/data';
import { requestBuilder } from '../helpers/requestBuilder';
import { calculator } from '../helpers/decorators';

import { SingleInput, RadioInput, TextArea } from '../components/inputs';
import { IncomeDeclaration } from '../components/IncomeDeclaration';
import { parseFromAPI, prepareForAPI } from '../helpers/formatRebateForm';

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
  cancelEdit () {
    window.location = `/admin/rebate_forms/${this.props.rebateForm.id}`;
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
          if (res.ok) window.location = `/admin/rebate_forms/${this.props.rebateForm.id}`;
          else console.error(res);
        });
  }

  render () {
    const {
      rebateForm,
      isReadOnly
    } = this.props;

    const fields = parseFromAPI(rebateForm);

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
          const {
            fields:
            { income_less_than_5k,
              lived_in_property_1_July,
              spouse_or_partner,
              moved_within_rating_year,
              income: {total_income}
            },
            newIncomeField
          } = values;

          const includePartnerValues = spouse_or_partner == 'yes';
          const renderConditionals = lived_in_property_1_July == 'no' &&
          moved_within_rating_year == 'yes';
          const showIncomeLessThan5k = isReadOnly
            ? income_less_than_5k 
            : income_less_than_5k || total_income < 5000;
          return (
            <div>
              <form
                onSubmit={handleSubmit}
              >
                { !isReadOnly && 
                <>
                  <div className="flex-row">
                    <div className="button-container">
                      <button className="pure-button rebate-cancel-button" type="button" onClick={this.cancelEdit.bind(this)} >
                        CANCEL
                      </button>
                      <button className="pure-button rebate-submit-button" type="submit" >
                        SAVE
                      </button>
                    </div>
                  </div>
                </>
                }
                <div className="rebate-edit-form">
                  <div className="flex-row">
                    {map(customerDetailFields, (field, index) => {
                      if (indexOf([1, 4, 6, 8, 10, 12], index) >= 0) field.withMargin = true;
                      return field.type == 'radio'
                        ? RadioInput({...field, isReadOnly, values})
                        : SingleInput({...field, isReadOnly});
                    })}
                  </div>
                  {  renderConditionals &&
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
                        disabled={isReadOnly || !newIncomeField}
                        type="button"
                        onClick={() => this.addNewIncomeValue(values)}
                      >
                          Add Income Type
                      </button>
                    </div>
                  </Fragment>
                  }
                  {showIncomeLessThan5k && TextArea({...income_less_than_5kField, isReadOnly})}
                </div>
              </form>
            </div>
          );}}
      </Form>
    );
  }
}

export default EditRebateForm;
